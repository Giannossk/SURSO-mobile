import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/network/dio_client.dart';
import '../organizer_events_provider.dart';

/// Scans a registrant's ticket QR (JSON `{userId, eventId, at}`, generated
/// server-side — see `backend/src/utils/qrcode.js`) and checks them in for
/// [eventId].
class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> {
  final _controller = MobileScannerController();
  bool _processing = false;
  String? _lastMessage;
  bool _lastWasError = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_processing) return;
    if (capture.barcodes.isEmpty) return;
    final raw = capture.barcodes.first.rawValue;
    if (raw == null) return;

    setState(() => _processing = true);
    try {
      final payload = jsonDecode(raw) as Map<String, dynamic>;
      final userId = payload['userId'] as String?;
      final scannedEventId = payload['eventId'] as String?;

      if (userId == null || scannedEventId == null) {
        _setResult('Unrecognized QR code', isError: true);
        return;
      }
      if (scannedEventId != widget.eventId) {
        _setResult('This ticket is for a different event', isError: true);
        return;
      }

      await ref.read(organizerEventActionsProvider.notifier).checkIn(widget.eventId, userId);
      _setResult('Checked in successfully', isError: false);
    } on FormatException {
      _setResult('Unrecognized QR code', isError: true);
    } on DioException catch (e) {
      final message = dioErrorMessage(e);
      _setResult(
        message.toLowerCase().contains('not found') ? 'Not registered for this event' : message,
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _processing = false);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _lastMessage = null);
      });
    }
  }

  void _setResult(String message, {required bool isError}) {
    if (!mounted) return;
    setState(() {
      _lastMessage = message;
      _lastWasError = isError;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan ticket'), actions: [
        IconButton(icon: const Icon(Icons.flash_on), onPressed: () => _controller.toggleTorch()),
      ]),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(controller: _controller, onDetect: _handleDetection),
          if (_processing) const Center(child: CircularProgressIndicator()),
          if (_lastMessage != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 32,
              child: Material(
                color: _lastWasError ? Colors.red.shade700 : Colors.green.shade700,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_lastMessage!, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
