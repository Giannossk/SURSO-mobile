import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/event_card.dart';
import '../../auth/auth_provider.dart';
import '../../notifications/widgets/notification_bell.dart';
import '../organizer_events_provider.dart';
import 'event_form_screen.dart';
import 'organizer_event_screen.dart';

class OrganizerHomeScreen extends ConsumerStatefulWidget {
  const OrganizerHomeScreen({super.key});

  @override
  ConsumerState<OrganizerHomeScreen> createState() => _OrganizerHomeScreenState();
}

class _OrganizerHomeScreenState extends ConsumerState<OrganizerHomeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizer'),
        actions: [
          const NotificationBell(),
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () => context.push('/profile')),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Events'),
            Tab(text: 'Past Events'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EventFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('New event'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _OrganizerEventList(showUpcoming: true),
          _OrganizerEventList(showUpcoming: false),
          _AnalyticsTab(),
        ],
      ),
    );
  }
}

class _OrganizerEventList extends ConsumerWidget {
  const _OrganizerEventList({required this.showUpcoming});

  final bool showUpcoming;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(organizerEventsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(organizerEventsProvider);
        await ref.read(organizerEventsProvider.future);
      },
      child: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load events.\n$error')),
        data: (events) {
          final now = DateTime.now();
          final filtered = events.where((e) => showUpcoming ? e.date.isAfter(now) : e.date.isBefore(now)).toList();

          if (filtered.isEmpty) {
            return ListView(
              children: [
                const SizedBox(height: 120),
                Center(child: Text(showUpcoming ? 'No upcoming events yet' : 'No past events')),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final event = filtered[index];
              return EventCard(
                event: event,
                trailing: Chip(label: Text(event.status), visualDensity: VisualDensity.compact),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => OrganizerEventScreen(eventId: event.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AnalyticsTab extends ConsumerWidget {
  const _AnalyticsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(organizerEventsProvider);

    return eventsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Could not load analytics.\n$error')),
      data: (events) {
        final approved = events.where((e) => e.status == 'approved').length;
        final pending = events.where((e) => e.status == 'pending').length;
        final rejected = events.where((e) => e.status == 'rejected').length;
        final totalRegistrations = events.fold<int>(0, (sum, e) => sum + e.registeredCount);
        final byCategory = <String, int>{};
        for (final e in events) {
          byCategory[e.category] = (byCategory[e.category] ?? 0) + 1;
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(child: _StatCard(label: 'Approved', value: '$approved', color: Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(label: 'Pending', value: '$pending', color: Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(label: 'Rejected', value: '$rejected', color: Colors.red)),
              ],
            ),
            const SizedBox(height: 12),
            _StatCard(label: 'Total registrations', value: '$totalRegistrations', color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 24),
            Text('Events by category', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...byCategory.entries.map(
              (e) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(e.key),
                trailing: Text('${e.value}'),
              ),
            ),
            const SizedBox(height: 16),
            Text('Upcoming', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...events.where((e) => e.date.isAfter(DateTime.now())).take(5).map(
                  (e) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.event),
                    title: Text(e.title),
                    subtitle: Text(DateFormat('MMM d, y').format(e.date)),
                  ),
                ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color)),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
