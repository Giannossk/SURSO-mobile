import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/app_notification.dart';
import '../notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  IconData _iconFor(String type) {
    switch (type) {
      case 'registration_confirmed':
        return Icons.confirmation_number_outlined;
      case 'event_approved':
        return Icons.check_circle_outline;
      case 'event_rejected':
        return Icons.cancel_outlined;
      case 'waitlist_promoted':
        return Icons.trending_up;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => ref.read(notificationsProvider.notifier).markAllRead(),
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load notifications.\n$error')),
        data: (state) {
          if (state.items.isEmpty) {
            return const Center(child: Text('No notifications yet'));
          }
          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) => _NotificationTile(
              notification: state.items[index],
              icon: _iconFor(state.items[index].type),
            ),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.notification, required this.icon});

  final AppNotification notification;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline),
      ),
      onDismissed: (_) => ref.read(notificationsProvider.notifier).delete(notification.id),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(notification.message, style: TextStyle(fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold)),
        subtitle: notification.createdAt != null ? Text(DateFormat('MMM d, y · h:mm a').format(notification.createdAt!)) : null,
        trailing: notification.isRead ? null : const Icon(Icons.circle, size: 10, color: Colors.blue),
        onTap: () {
          if (!notification.isRead) {
            ref.read(notificationsProvider.notifier).markRead(notification.id);
          }
        },
      ),
    );
  }
}
