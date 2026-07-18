import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/event_card.dart';
import '../../customer/saved_events_provider.dart';
import '../events_provider.dart';

class EventListScreen extends ConsumerStatefulWidget {
  const EventListScreen({super.key});

  @override
  ConsumerState<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends ConsumerState<EventListScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(eventSearchQueryProvider.notifier).set(value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsProvider);
    final tagsAsync = ref.watch(popularTagsProvider);
    final selectedCategory = ref.watch(eventCategoryFilterProvider);
    final savedAsync = ref.watch(savedEventsProvider);
    final savedIds = savedAsync.value?.map((e) => e.id).toSet() ?? <String>{};

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(eventsProvider);
        ref.invalidate(savedEventsProvider);
        await ref.read(eventsProvider.future);
      },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search events…',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          tagsAsync.when(
            data: (tags) => SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('All'),
                        selected: selectedCategory == null,
                        onSelected: (_) => ref.read(eventCategoryFilterProvider.notifier).set(null),
                      ),
                    ),
                    for (final tag in tags)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(tag),
                          selected: selectedCategory == tag,
                          onSelected: (_) => ref
                              .read(eventCategoryFilterProvider.notifier)
                              .set(selectedCategory == tag ? null : tag),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          eventsAsync.when(
            data: (events) {
              if (events.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No events match your search')),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList.separated(
                  itemCount: events.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventCard(
                      event: event,
                      isSaved: savedIds.contains(event.id),
                      onTap: () => context.push('/events/${event.id}'),
                      onToggleSave: () => ref.read(saveEventActionProvider.notifier).toggle(event.id),
                    );
                  },
                ),
              );
            },
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (error, _) => SliverFillRemaining(
              child: Center(child: Text('Could not load events.\n$error', textAlign: TextAlign.center)),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
