import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_client.dart';
import '../../models/app_notification.dart';

part 'notification_repository.g.dart';

class NotificationRepository {
  NotificationRepository(this._dio);

  final Dio _dio;

  /// Returns `(notifications, unreadCount)`.
  Future<(List<AppNotification>, int)> list() async {
    final res = await _dio.get('/notifications');
    final data = res.data as Map<String, dynamic>;
    final items = (data['notifications'] as List).map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList();
    return (items, (data['unreadCount'] as num?)?.toInt() ?? 0);
  }

  Future<int> unreadCount() async {
    final res = await _dio.get('/notifications/unread-count');
    return ((res.data as Map<String, dynamic>)['unreadCount'] as num?)?.toInt() ?? 0;
  }

  Future<void> markAllRead() => _dio.patch('/notifications/read-all');

  Future<void> markRead(String id) => _dio.patch('/notifications/$id/read');

  Future<void> delete(String id) => _dio.delete('/notifications/$id');
}

@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(Ref ref) => NotificationRepository(ref.watch(dioProvider));
