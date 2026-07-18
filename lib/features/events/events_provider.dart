import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/event_repository.dart';
import '../../models/event.dart';

part 'events_provider.g.dart';

@riverpod
class EventSearchQuery extends _$EventSearchQuery {
  @override
  String build() => '';

  void set(String value) => state = value;
}

@riverpod
class EventCategoryFilter extends _$EventCategoryFilter {
  @override
  String? build() => null;

  void set(String? value) => state = value;
}

@riverpod
Future<List<Event>> events(Ref ref) {
  final search = ref.watch(eventSearchQueryProvider);
  final category = ref.watch(eventCategoryFilterProvider);
  return ref.watch(eventRepositoryProvider).listEvents(
        q: search.isEmpty ? null : search,
        category: category,
        status: 'approved',
      );
}

@riverpod
Future<List<String>> popularTags(Ref ref) {
  return ref.watch(eventRepositoryProvider).popularTags();
}

@riverpod
Future<Event> eventDetail(Ref ref, String id) {
  return ref.watch(eventRepositoryProvider).getEvent(id);
}
