import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_client.dart';
import '../../models/event.dart';
import '../../models/user.dart';

part 'admin_repository.g.dart';

class BulkActionSummary {
  const BulkActionSummary({required this.succeeded, required this.failed, this.errors = const []});

  final int succeeded;
  final int failed;
  final List<String> errors;

  factory BulkActionSummary.fromJson(Map<String, dynamic> json) {
    return BulkActionSummary(
      succeeded: (json['succeeded'] as num?)?.toInt() ?? 0,
      failed: (json['failed'] as num?)?.toInt() ?? 0,
      errors: (json['errors'] as List?)
              ?.map((e) => (e as Map)['error']?.toString() ?? 'Unknown error')
              .toList() ??
          const [],
    );
  }
}

class AdminRepository {
  AdminRepository(this._dio);

  final Dio _dio;

  Future<List<Event>> pendingEvents() async {
    final res = await _dio.get('/admin/events/pending');
    final items = (res.data as Map<String, dynamic>)['events'] as List;
    return items.map((e) => Event.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> approveEvent(String id) => _dio.post('/admin/events/$id/approve');

  Future<void> rejectEvent(String id, String reason) =>
      _dio.post('/admin/events/$id/reject', data: {'reason': reason});

  Future<BulkActionSummary> bulkApprove(List<String> eventIds) async {
    final res = await _dio.post('/admin/events/bulk-approve', data: {'eventIds': eventIds});
    return BulkActionSummary.fromJson(res.data as Map<String, dynamic>);
  }

  Future<BulkActionSummary> bulkReject(List<String> eventIds, String reason) async {
    final res = await _dio.post('/admin/events/bulk-reject', data: {'eventIds': eventIds, 'rejectionReason': reason});
    return BulkActionSummary.fromJson(res.data as Map<String, dynamic>);
  }

  Future<BulkActionSummary> bulkDelete(List<String> eventIds) async {
    final res = await _dio.post('/admin/events/bulk-delete', data: {'eventIds': eventIds});
    return BulkActionSummary.fromJson(res.data as Map<String, dynamic>);
  }

  Future<List<User>> allUsers() async {
    final res = await _dio.get('/admin/users');
    final items = (res.data as Map<String, dynamic>)['users'] as List;
    return items.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> blockUser(String id) => _dio.post('/admin/users/$id/block');

  Future<void> unblockUser(String id) => _dio.post('/admin/users/$id/unblock');

  Future<void> updateUserRole(String id, String role) =>
      _dio.put('/admin/users/$id/role', data: {'role': role});
}

@Riverpod(keepAlive: true)
AdminRepository adminRepository(Ref ref) => AdminRepository(ref.watch(dioProvider));
