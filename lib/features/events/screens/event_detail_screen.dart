import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/socket_service.dart';
import '../../../models/event.dart';
import '../../../models/registration.dart';
import '../../auth/auth_provider.dart';
import '../../auth/auth_state.dart';
import '../../customer/registrations_provider.dart';
import '../../customer/saved_events_provider.dart';
import '../events_provider.dart';
import '../reviews_provider.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  int? _liveCount;

  @override
  void initState() {
    super.initState();
    final socket = ref.read(socketServiceProvider).socket;
    ref.read(socketServiceProvider).joinEvent(widget.eventId);
    socket?.on('registration:count', _onRegistrationCount);
  }

  void _onRegistrationCount(dynamic data) {
    if (data is Map && data['eventId'] == widget.eventId && mounted) {
      setState(() => _liveCount = (data['count'] as num?)?.toInt());
    }
  }

  @override
  void dispose() {
    ref.read(socketServiceProvider).socket?.off('registration:count', _onRegistrationCount);
    ref.read(socketServiceProvider).leaveEvent(widget.eventId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventDetailProvider(widget.eventId));
    final reviewsAsync = ref.watch(eventReviewsProvider(widget.eventId));
    final myRegs = ref.watch(myRegistrationsProvider).value ?? const <Registration>[];
    Registration? myReg;
    for (final r in myRegs) {
      if (r.eventId == widget.eventId && !r.isCancelled) {
        myReg = r;
        break;
      }
    }
    final savedIds = ref.watch(savedEventsProvider).value?.map((e) => e.id).toSet() ?? <String>{};
    final isSaved = savedIds.contains(widget.eventId);

    return Scaffold(
      body: eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load event.\n$error')),
        data: (event) {
          final count = _liveCount ?? event.registeredCount;
          final theme = Theme.of(context);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                actions: [
                  IconButton(
                    icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border),
                    onPressed: () => ref.read(saveEventActionProvider.notifier).toggle(event.id),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: event.posterUrl != null && event.posterUrl!.isNotEmpty
                      ? CachedNetworkImage(imageUrl: event.posterUrl!, fit: BoxFit.cover)
                      : Container(color: theme.colorScheme.surfaceContainerHighest),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList.list(children: [
                  Text(event.title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    Chip(label: Text(event.category)),
                    Chip(label: Text(event.isFree ? 'Free' : '\$${event.price}')),
                    if (event.averageRating > 0)
                      Chip(avatar: const Icon(Icons.star, size: 16), label: Text(event.averageRating.toStringAsFixed(1))),
                  ]),
                  const SizedBox(height: 16),
                  _InfoRow(icon: Icons.event, label: DateFormat('EEEE, MMM d, y · h:mm a').format(event.date)),
                  _InfoRow(icon: Icons.place_outlined, label: event.location),
                  _InfoRow(
                    icon: Icons.groups_outlined,
                    label: '$count / ${event.capacity} registered · ${event.isFull ? 'Full' : '${event.spotsLeft} spots left'}',
                  ),
                  if (event.organizer != null) _InfoRow(icon: Icons.person_outline, label: 'By ${event.organizer!.name}'),
                  const SizedBox(height: 16),
                  Text('About this event', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(event.description),
                  const SizedBox(height: 24),
                  _RegisterButton(event: event, myRegistration: myReg),
                  const SizedBox(height: 24),
                  Text('Reviews', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  reviewsAsync.when(
                    data: (reviews) => reviews.isEmpty
                        ? const Text('No reviews yet.')
                        : Column(
                            children: reviews
                                .map((r) => ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(Icons.person),
                                      title: Text(r.user?.name ?? 'Anonymous'),
                                      subtitle: Text(r.comment ?? ''),
                                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                        const Icon(Icons.star, size: 16, color: Colors.amber),
                                        Text('${r.rating}'),
                                      ]),
                                    ))
                                .toList(),
                          ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  if (myReg?.isAttended ?? false) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.rate_review_outlined),
                      label: const Text('Leave a review'),
                      onPressed: () => _showReviewSheet(context, event.id),
                    ),
                  ],
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showReviewSheet(BuildContext context, String eventId) {
    int rating = 5;
    final commentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: StatefulBuilder(
          builder: (context, setSheetState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Leave a review', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final starValue = i + 1;
                  return IconButton(
                    icon: Icon(starValue <= rating ? Icons.star : Icons.star_border, color: Colors.amber),
                    onPressed: () => setSheetState(() => rating = starValue),
                  );
                }),
              ),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(labelText: 'Comment (optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  await ref.read(reviewActionsProvider.notifier).add(eventId, rating: rating, comment: commentController.text.trim());
                  if (context.mounted) Navigator.of(context).pop();
                },
                child: const Text('Submit review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}

class _RegisterButton extends ConsumerStatefulWidget {
  const _RegisterButton({required this.event, required this.myRegistration});

  final Event event;
  final Registration? myRegistration;

  @override
  ConsumerState<_RegisterButton> createState() => _RegisterButtonState();
}

class _RegisterButtonState extends ConsumerState<_RegisterButton> {
  bool _loading = false;

  Future<void> _register() async {
    setState(() => _loading = true);
    try {
      await ref.read(registrationActionsProvider.notifier).register(widget.event.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registered successfully')));
      }
    } on DioException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _cancel() async {
    final reg = widget.myRegistration;
    if (reg == null) return;
    setState(() => _loading = true);
    try {
      await ref.read(registrationActionsProvider.notifier).cancel(reg.id, widget.event.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration cancelled')));
      }
    } on DioException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider).value;
    final isOrganizerOrAdmin = authState is AuthAuthenticated && !authState.user.isCustomer;
    final reg = widget.myRegistration;

    if (isOrganizerOrAdmin) return const SizedBox.shrink();

    if (reg != null) {
      final label = reg.isWaitlisted ? 'Waitlisted' : reg.isAttended ? 'Attended' : 'You\'re registered';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Chip(label: Text(label), avatar: const Icon(Icons.check_circle, size: 18)),
          const SizedBox(height: 8),
          if (!reg.isAttended)
            OutlinedButton(
              onPressed: _loading ? null : _cancel,
              child: _loading ? const _ButtonSpinner() : const Text('Cancel registration'),
            ),
        ],
      );
    }

    final event = widget.event;
    final full = event.isFull;
    return FilledButton(
      onPressed: (_loading || full) ? null : _register,
      child: _loading
          ? const _ButtonSpinner()
          : Text(full ? 'Event full — join waitlist' : 'Register'),
    );
  }
}

class _ButtonSpinner extends StatelessWidget {
  const _ButtonSpinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2));
  }
}
