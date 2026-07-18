import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../models/registration.dart';
import '../registrations_provider.dart';

class MyTicketsScreen extends ConsumerWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regsAsync = ref.watch(myRegistrationsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(myRegistrationsProvider);
        await ref.read(myRegistrationsProvider.future);
      },
      child: regsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load tickets.\n$error')),
        data: (regs) {
          final active = regs.where((r) => !r.isCancelled).toList()
            ..sort((a, b) => (a.event?.date ?? DateTime(0)).compareTo(b.event?.date ?? DateTime(0)));

          if (active.isEmpty) {
            return ListView(
              children: const [
                SizedBox(height: 120),
                Center(child: Text('No tickets yet — register for an event to see it here.')),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: active.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _TicketTile(registration: active[index]),
          );
        },
      ),
    );
  }
}

class _TicketTile extends StatelessWidget {
  const _TicketTile({required this.registration});

  final Registration registration;

  @override
  Widget build(BuildContext context) {
    final event = registration.event;
    final theme = Theme.of(context);
    final statusColor = switch (registration.status) {
      'waitlisted' => theme.colorScheme.tertiary,
      'attended' => theme.colorScheme.primary,
      _ => theme.colorScheme.secondary,
    };

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.15),
          child: Icon(Icons.confirmation_number_outlined, color: statusColor),
        ),
        title: Text(event?.title ?? 'Event'),
        subtitle: Text(event != null ? DateFormat('EEE, MMM d, y · h:mm a').format(event.date) : ''),
        trailing: Chip(label: Text(registration.status), visualDensity: VisualDensity.compact),
        onTap: () => context.push('/tickets/${registration.id}'),
      ),
    );
  }
}
