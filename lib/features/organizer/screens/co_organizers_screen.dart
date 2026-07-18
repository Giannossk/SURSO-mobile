import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../../events/events_provider.dart';
import '../organizer_events_provider.dart';

class CoOrganizersScreen extends ConsumerStatefulWidget {
  const CoOrganizersScreen({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<CoOrganizersScreen> createState() => _CoOrganizersScreenState();
}

class _CoOrganizersScreenState extends ConsumerState<CoOrganizersScreen> {
  final _emailController = TextEditingController();
  bool _adding = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    setState(() => _adding = true);
    try {
      await ref.read(organizerEventActionsProvider.notifier).addCoOrganizer(widget.eventId, email);
      _emailController.clear();
    } on DioException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  Future<void> _remove(String userId) async {
    try {
      await ref.read(organizerEventActionsProvider.notifier).removeCoOrganizer(widget.eventId, userId);
    } on DioException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dioErrorMessage(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventDetailProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(title: const Text('Co-organizers')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Co-organizer email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _adding ? null : _add,
                  child: _adding
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: eventAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Could not load event.\n$error')),
                data: (event) {
                  if (event.coOrganizerIds.isEmpty) {
                    return const Center(child: Text('No co-organizers yet'));
                  }
                  return ListView.builder(
                    itemCount: event.coOrganizerIds.length,
                    itemBuilder: (context, index) {
                      final id = event.coOrganizerIds[index];
                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(id),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _remove(id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
