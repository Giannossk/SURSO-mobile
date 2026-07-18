import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/network/dio_client.dart';
import '../../auth/auth_provider.dart';
import '../../auth/auth_state.dart';
import '../certificate.dart';
import '../registrations_provider.dart';

class TicketDetailScreen extends ConsumerStatefulWidget {
  const TicketDetailScreen({super.key, required this.registrationId});

  final String registrationId;

  @override
  ConsumerState<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends ConsumerState<TicketDetailScreen> {
  bool _cancelling = false;

  Future<void> _cancel(String registrationId, String eventId) async {
    setState(() => _cancelling = true);
    try {
      await ref.read(registrationActionsProvider.notifier).cancel(registrationId, eventId);
      if (mounted) context.pop();
    } on DioException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _cancelling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final regAsync = ref.watch(registrationByIdProvider(widget.registrationId));
    final authState = ref.watch(authProvider).value;
    final attendeeName = authState is AuthAuthenticated ? authState.user.name : '';

    return Scaffold(
      appBar: AppBar(title: const Text('Ticket')),
      body: regAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load ticket.\n$error')),
        data: (reg) {
          if (reg == null) return const Center(child: Text('Ticket not found'));
          final event = reg.event;

          final qrBytes = _decodeQr(reg.qrCodeDataUrl);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (event != null) ...[
                  Text(event.title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text(DateFormat('EEEE, MMM d, y · h:mm a').format(event.date), textAlign: TextAlign.center),
                  Text(event.location, textAlign: TextAlign.center),
                ],
                const SizedBox(height: 24),
                Chip(label: Text(reg.status)),
                const SizedBox(height: 24),
                if (qrBytes != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.memory(qrBytes, width: 220, height: 220),
                  )
                else
                  const Text('QR code not available for this ticket.'),
                const SizedBox(height: 32),
                if (reg.isAttended && event != null)
                  FilledButton.icon(
                    icon: const Icon(Icons.workspace_premium_outlined),
                    label: const Text('Download certificate'),
                    onPressed: () => shareCertificate(event: event, attendeeName: attendeeName),
                  ),
                const SizedBox(height: 12),
                if (!reg.isCancelled && !reg.isAttended)
                  OutlinedButton(
                    onPressed: _cancelling || event == null ? null : () => _cancel(reg.id, event.id),
                    child: _cancelling
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Cancel registration'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Uint8List? _decodeQr(String? dataUrl) {
    if (dataUrl == null || !dataUrl.contains(',')) return null;
    try {
      return base64Decode(dataUrl.split(',').last);
    } catch (_) {
      return null;
    }
  }
}
