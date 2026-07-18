import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/user_repository.dart';
import '../../models/event.dart';

part 'saved_events_provider.g.dart';

@riverpod
Future<List<Event>> savedEvents(Ref ref) {
  return ref.watch(userRepositoryProvider).savedEvents();
}

@riverpod
class SaveEventAction extends _$SaveEventAction {
  @override
  void build() {}

  Future<void> toggle(String eventId) async {
    await ref.read(userRepositoryProvider).toggleSaveEvent(eventId);
    ref.invalidate(savedEventsProvider);
  }
}
