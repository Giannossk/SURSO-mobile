import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/admin_repository.dart';
import '../../data/repositories/event_repository.dart';
import '../../models/event.dart';
import '../../models/user.dart';

part 'admin_provider.g.dart';

@riverpod
Future<List<Event>> pendingEvents(Ref ref) {
  return ref.watch(adminRepositoryProvider).pendingEvents();
}

@riverpod
Future<List<Event>> allEventsAdmin(Ref ref) {
  return ref.watch(eventRepositoryProvider).listEvents();
}

@riverpod
Future<List<User>> allUsers(Ref ref) {
  return ref.watch(adminRepositoryProvider).allUsers();
}

@riverpod
class AdminActions extends _$AdminActions {
  @override
  void build() {}

  void _invalidateEventLists() {
    ref.invalidate(pendingEventsProvider);
    ref.invalidate(allEventsAdminProvider);
  }

  Future<void> approve(String eventId) async {
    await ref.read(adminRepositoryProvider).approveEvent(eventId);
    _invalidateEventLists();
  }

  Future<void> reject(String eventId, String reason) async {
    await ref.read(adminRepositoryProvider).rejectEvent(eventId, reason);
    _invalidateEventLists();
  }

  Future<BulkActionSummary> bulkApprove(List<String> eventIds) async {
    final summary = await ref.read(adminRepositoryProvider).bulkApprove(eventIds);
    _invalidateEventLists();
    return summary;
  }

  Future<BulkActionSummary> bulkReject(List<String> eventIds, String reason) async {
    final summary = await ref.read(adminRepositoryProvider).bulkReject(eventIds, reason);
    _invalidateEventLists();
    return summary;
  }

  Future<BulkActionSummary> bulkDelete(List<String> eventIds) async {
    final summary = await ref.read(adminRepositoryProvider).bulkDelete(eventIds);
    _invalidateEventLists();
    return summary;
  }

  Future<void> blockUser(String userId) async {
    await ref.read(adminRepositoryProvider).blockUser(userId);
    ref.invalidate(allUsersProvider);
  }

  Future<void> unblockUser(String userId) async {
    await ref.read(adminRepositoryProvider).unblockUser(userId);
    ref.invalidate(allUsersProvider);
  }

  Future<void> updateUserRole(String userId, String role) async {
    await ref.read(adminRepositoryProvider).updateUserRole(userId, role);
    ref.invalidate(allUsersProvider);
  }
}
