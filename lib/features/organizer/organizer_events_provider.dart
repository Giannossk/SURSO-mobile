import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/event_repository.dart';
import '../../data/repositories/registration_repository.dart';
import '../../data/repositories/stats_repository.dart';
import '../../models/event.dart';
import '../../models/registration.dart';
import '../auth/auth_provider.dart';
import '../auth/auth_state.dart';
import '../events/events_provider.dart';

part 'organizer_events_provider.g.dart';

@riverpod
Future<List<Event>> organizerEvents(Ref ref) async {
  final authState = ref.watch(authProvider).value;
  if (authState is! AuthAuthenticated) return const [];
  return ref.watch(eventRepositoryProvider).listEvents(organizer: authState.user.id);
}

@riverpod
Future<Map<String, dynamic>> organizerDashboardStats(Ref ref) {
  return ref.watch(statsRepositoryProvider).dashboard();
}

@riverpod
Future<List<Registration>> eventParticipants(Ref ref, String eventId) {
  return ref.watch(registrationRepositoryProvider).participantsFor(eventId);
}

@riverpod
class OrganizerEventActions extends _$OrganizerEventActions {
  @override
  void build() {}

  Future<Event> create(EventDraft draft, {String? posterPath}) async {
    final event = await ref.read(eventRepositoryProvider).createEvent(draft, posterPath: posterPath);
    ref.invalidate(organizerEventsProvider);
    return event;
  }

  Future<Event> update(String id, EventDraft draft, {String? posterPath}) async {
    final event = await ref.read(eventRepositoryProvider).updateEvent(id, draft, posterPath: posterPath);
    ref.invalidate(organizerEventsProvider);
    ref.invalidate(eventDetailProvider(id));
    return event;
  }

  Future<void> delete(String id) async {
    await ref.read(eventRepositoryProvider).deleteEvent(id);
    ref.invalidate(organizerEventsProvider);
  }

  Future<void> sendReminders(String id) => ref.read(eventRepositoryProvider).sendReminders(id);

  Future<void> addCoOrganizer(String eventId, String email) async {
    await ref.read(eventRepositoryProvider).addCoOrganizer(eventId, email);
    ref.invalidate(eventDetailProvider(eventId));
  }

  Future<void> removeCoOrganizer(String eventId, String userId) async {
    await ref.read(eventRepositoryProvider).removeCoOrganizer(eventId, userId);
    ref.invalidate(eventDetailProvider(eventId));
  }

  Future<void> checkIn(String eventId, String userId, {String status = 'attended'}) async {
    await ref.read(registrationRepositoryProvider).checkIn(eventId, userId, status: status);
    ref.invalidate(eventParticipantsProvider(eventId));
  }
}
