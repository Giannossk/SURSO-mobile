import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/network/dio_client.dart';
import '../../events/events_provider.dart';
import '../organizer_events_provider.dart';
import 'checkin_list_screen.dart';
import 'co_organizers_screen.dart';
import 'event_form_screen.dart';
import 'qr_scanner_screen.dart';

class OrganizerEventScreen extends ConsumerWidget {
  const OrganizerEventScreen({super.key, required this.eventId});

  final String eventId;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete event?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(organizerEventActionsProvider.notifier).delete(eventId);
      if (context.mounted) context.pop();
    } on DioException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
      }
    }
  }

  Future<void> _remind(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(organizerEventActionsProvider.notifier).sendReminders(eventId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reminders sent')));
      }
    } on DioException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage event'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              final event = eventAsync.value;
              if (event != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => EventFormScreen(event: event)),
                );
              }
            },
          ),
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _delete(context, ref)),
        ],
      ),
      body: eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load event.\n$error')),
        data: (event) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(event.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(DateFormat('EEEE, MMM d, y · h:mm a').format(event.date)),
              const SizedBox(height: 8),
              Chip(label: Text(event.status)),
              const SizedBox(height: 24),
              _ActionTile(
                icon: Icons.qr_code_scanner,
                title: 'Scan tickets',
                subtitle: 'Check attendees in with the camera',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => QrScannerScreen(eventId: event.id)),
                ),
              ),
              _ActionTile(
                icon: Icons.checklist,
                title: 'Manual check-in',
                subtitle: 'Search participants and check in by hand',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => CheckinListScreen(eventId: event.id)),
                ),
              ),
              _ActionTile(
                icon: Icons.group_add_outlined,
                title: 'Co-organizers',
                subtitle: 'Manage who else can manage this event',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => CoOrganizersScreen(eventId: event.id)),
                ),
              ),
              _ActionTile(
                icon: Icons.notifications_active_outlined,
                title: 'Send reminders',
                subtitle: 'Email all registered participants',
                onTap: () => _remind(context, ref),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
