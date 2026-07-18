import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/network/dio_client.dart';
import '../admin_provider.dart';

class AllEventsScreen extends ConsumerStatefulWidget {
  const AllEventsScreen({super.key});

  @override
  ConsumerState<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends ConsumerState<AllEventsScreen> {
  final Set<String> _selected = {};
  bool _busy = false;

  Future<void> _bulkDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${_selected.length} events?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    try {
      final summary = await ref.read(adminActionsProvider.notifier).bulkDelete(_selected.toList());
      setState(() => _selected.clear());
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Deleted ${summary.succeeded}, failed ${summary.failed}')));
      }
    } on DioException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(allEventsAdminProvider);

    return Column(
      children: [
        if (_selected.isNotEmpty)
          Material(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text('${_selected.length} selected'),
                  const Spacer(),
                  TextButton(onPressed: _busy ? null : _bulkDelete, child: const Text('Delete all')),
                ],
              ),
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(allEventsAdminProvider);
              await ref.read(allEventsAdminProvider.future);
            },
            child: eventsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Could not load events.\n$error')),
              data: (events) {
                if (events.isEmpty) return const Center(child: Text('No events'));
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final selected = _selected.contains(event.id);
                    return CheckboxListTile(
                      value: selected,
                      onChanged: (v) => setState(() {
                        if (v ?? false) {
                          _selected.add(event.id);
                        } else {
                          _selected.remove(event.id);
                        }
                      }),
                      title: Text(event.title),
                      subtitle: Text('${DateFormat('MMM d, y').format(event.date)} · ${event.status}'),
                      secondary: CircleAvatar(
                        backgroundColor: _statusColor(event.status, context).withValues(alpha: 0.15),
                        child: Icon(Icons.event, color: _statusColor(event.status, context)),
                      ),
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

  Color _statusColor(String status, BuildContext context) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
