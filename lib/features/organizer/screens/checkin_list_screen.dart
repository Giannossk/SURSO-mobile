import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../../../models/registration.dart';
import '../organizer_events_provider.dart';

class CheckinListScreen extends ConsumerStatefulWidget {
  const CheckinListScreen({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<CheckinListScreen> createState() => _CheckinListScreenState();
}

class _CheckinListScreenState extends ConsumerState<CheckinListScreen> {
  String _query = '';
  bool _onlyPending = false;

  @override
  Widget build(BuildContext context) {
    final participantsAsync = ref.watch(eventParticipantsProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(hintText: 'Search participants…', prefixIcon: Icon(Icons.search)),
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            ),
          ),
          SwitchListTile(
            title: const Text('Only pending check-in'),
            value: _onlyPending,
            onChanged: (v) => setState(() => _onlyPending = v),
          ),
          Expanded(
            child: participantsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Could not load participants.\n$error')),
              data: (participants) {
                final filtered = participants.where((r) {
                  final name = r.user?.name.toLowerCase() ?? '';
                  final email = r.user?.email.toLowerCase() ?? '';
                  if (_query.isNotEmpty && !name.contains(_query) && !email.contains(_query)) return false;
                  if (_onlyPending && r.isAttended) return false;
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No participants match'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _ParticipantTile(eventId: widget.eventId, registration: filtered[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantTile extends ConsumerStatefulWidget {
  const _ParticipantTile({required this.eventId, required this.registration});

  final String eventId;
  final Registration registration;

  @override
  ConsumerState<_ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends ConsumerState<_ParticipantTile> {
  bool _loading = false;

  Future<void> _checkIn() async {
    final userId = widget.registration.userId;
    if (userId == null) return;
    setState(() => _loading = true);
    try {
      await ref.read(organizerEventActionsProvider.notifier).checkIn(widget.eventId, userId);
    } on DioException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reg = widget.registration;
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(reg.user?.name ?? 'Unknown'),
      subtitle: Text(reg.user?.email ?? ''),
      trailing: _loading
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : reg.isAttended
              ? const Chip(label: Text('Checked in'), avatar: Icon(Icons.check_circle, size: 16))
              : FilledButton(onPressed: _checkIn, child: const Text('Check in')),
    );
  }
}
