import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/network/dio_client.dart';
import '../admin_provider.dart';

class PendingReviewsScreen extends ConsumerStatefulWidget {
  const PendingReviewsScreen({super.key});

  @override
  ConsumerState<PendingReviewsScreen> createState() => _PendingReviewsScreenState();
}

class _PendingReviewsScreenState extends ConsumerState<PendingReviewsScreen> {
  final Set<String> _selected = {};
  bool _busy = false;

  Future<String?> _promptReason(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rejection reason'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'At least 20 characters…'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  Future<void> _bulkApprove() async {
    setState(() => _busy = true);
    try {
      final summary = await ref.read(adminActionsProvider.notifier).bulkApprove(_selected.toList());
      setState(() => _selected.clear());
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Approved ${summary.succeeded}, failed ${summary.failed}')));
      }
    } on DioException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _bulkReject() async {
    final reason = await _promptReason(context);
    if (reason == null || reason.length < 20) return;
    setState(() => _busy = true);
    try {
      final summary = await ref.read(adminActionsProvider.notifier).bulkReject(_selected.toList(), reason);
      setState(() => _selected.clear());
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Rejected ${summary.succeeded}, failed ${summary.failed}')));
      }
    } on DioException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(pendingEventsProvider);

    return Column(
      children: [
        if (_selected.isNotEmpty)
          Material(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text('${_selected.length} selected'),
                  const Spacer(),
                  TextButton(onPressed: _busy ? null : _bulkApprove, child: const Text('Approve all')),
                  TextButton(onPressed: _busy ? null : _bulkReject, child: const Text('Reject all')),
                ],
              ),
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(pendingEventsProvider);
              await ref.read(pendingEventsProvider.future);
            },
            child: eventsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Could not load pending events.\n$error')),
              data: (events) {
                if (events.isEmpty) {
                  return ListView(children: const [SizedBox(height: 120), Center(child: Text('No pending events'))]);
                }
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return _PendingEventTile(
                      eventId: event.id,
                      title: event.title,
                      organizerName: event.organizer?.name ?? 'Unknown',
                      dateLabel: DateFormat('MMM d, y').format(event.date),
                      selected: _selected.contains(event.id),
                      onSelectedChanged: (v) => setState(() {
                        if (v) {
                          _selected.add(event.id);
                        } else {
                          _selected.remove(event.id);
                        }
                      }),
                      onReject: () async {
                        final reason = await _promptReason(context);
                        if (reason == null || reason.length < 20) return;
                        try {
                          await ref.read(adminActionsProvider.notifier).reject(event.id, reason);
                        } on DioException catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
                          }
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _PendingEventTile extends ConsumerWidget {
  const _PendingEventTile({
    required this.eventId,
    required this.title,
    required this.organizerName,
    required this.dateLabel,
    required this.selected,
    required this.onSelectedChanged,
    required this.onReject,
  });

  final String eventId;
  final String title;
  final String organizerName;
  final String dateLabel;
  final bool selected;
  final ValueChanged<bool> onSelectedChanged;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Checkbox(value: selected, onChanged: (v) => onSelectedChanged(v ?? false)),
        title: Text(title),
        subtitle: Text('By $organizerName · $dateLabel'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.green),
              onPressed: () => ref.read(adminActionsProvider.notifier).approve(eventId),
            ),
            IconButton(
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
              onPressed: onReject,
            ),
          ],
        ),
      ),
    );
  }
}
