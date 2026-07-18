import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/registration_repository.dart';
import '../../models/registration.dart';
import '../events/events_provider.dart';

part 'registrations_provider.g.dart';

@riverpod
Future<List<Registration>> myRegistrations(Ref ref) {
  return ref.watch(registrationRepositoryProvider).myRegistrations();
}

@riverpod
Future<Registration?> registrationById(Ref ref, String id) async {
  final regs = await ref.watch(myRegistrationsProvider.future);
  for (final r in regs) {
    if (r.id == id) return r;
  }
  return null;
}

@riverpod
class RegistrationActions extends _$RegistrationActions {
  @override
  void build() {}

  Future<void> register(String eventId) async {
    await ref.read(registrationRepositoryProvider).register(eventId);
    ref.invalidate(myRegistrationsProvider);
    ref.invalidate(eventsProvider);
    ref.invalidate(eventDetailProvider(eventId));
  }

  Future<void> cancel(String registrationId, String eventId) async {
    await ref.read(registrationRepositoryProvider).cancel(registrationId);
    ref.invalidate(myRegistrationsProvider);
    ref.invalidate(eventsProvider);
    ref.invalidate(eventDetailProvider(eventId));
  }
}
