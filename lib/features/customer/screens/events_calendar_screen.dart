import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../models/registration.dart';
import '../registrations_provider.dart';

class EventsCalendarScreen extends ConsumerStatefulWidget {
  const EventsCalendarScreen({super.key});

  @override
  ConsumerState<EventsCalendarScreen> createState() => _EventsCalendarScreenState();
}

class _EventsCalendarScreenState extends ConsumerState<EventsCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final regsAsync = ref.watch(myRegistrationsProvider);

    return regsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Could not load calendar.\n$error')),
      data: (regs) {
        final active = regs.where((r) => !r.isCancelled && r.event != null).toList();
        final byDay = <DateTime, List<Registration>>{};
        for (final r in active) {
          final d = r.event!.date;
          final key = DateTime(d.year, d.month, d.day);
          byDay.putIfAbsent(key, () => []).add(r);
        }

        List<Registration> eventsForDay(DateTime day) {
          final key = DateTime(day.year, day.month, day.day);
          return byDay[key] ?? const [];
        }

        final selected = _selectedDay ?? _focusedDay;

        return Column(
          children: [
            TableCalendar<Registration>(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: eventsForDay,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            ),
            const Divider(height: 1),
            Expanded(
              child: eventsForDay(selected).isEmpty
                  ? const Center(child: Text('No events on this day'))
                  : ListView(
                      children: eventsForDay(selected)
                          .map((r) => ListTile(
                                leading: const Icon(Icons.event),
                                title: Text(r.event!.title),
                                subtitle: Text(DateFormat('h:mm a').format(r.event!.date)),
                                onTap: () => context.push('/tickets/${r.id}'),
                              ))
                          .toList(),
                    ),
            ),
          ],
        );
      },
    );
  }
}
