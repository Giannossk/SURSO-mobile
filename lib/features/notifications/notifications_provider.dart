import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/socket_service.dart';
import '../../data/repositories/notification_repository.dart';
import '../../models/app_notification.dart';

part 'notifications_provider.g.dart';

@riverpod
Stream<Map<String, dynamic>> socketNotificationStream(Ref ref) {
  return ref.watch(socketServiceProvider).onNotification;
}

class NotificationsState {
  const NotificationsState({required this.items, required this.unreadCount});

  final List<AppNotification> items;
  final int unreadCount;
}

@riverpod
class NotificationsNotifier extends _$NotificationsNotifier {
  @override
  Future<NotificationsState> build() async {
    ref.listen(socketNotificationStreamProvider, (previous, next) {
      if (next.hasValue) ref.invalidateSelf();
    });
    final (items, unreadCount) = await ref.watch(notificationRepositoryProvider).list();
    return NotificationsState(items: items, unreadCount: unreadCount);
  }

  Future<void> markRead(String id) async {
    await ref.read(notificationRepositoryProvider).markRead(id);
    ref.invalidateSelf();
  }

  Future<void> markAllRead() async {
    await ref.read(notificationRepositoryProvider).markAllRead();
    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    await ref.read(notificationRepositoryProvider).delete(id);
    ref.invalidateSelf();
  }
}
