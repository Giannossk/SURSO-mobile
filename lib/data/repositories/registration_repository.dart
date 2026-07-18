import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_client.dart';
import '../../models/registration.dart';

part 'registration_repository.g.dart';

class RegistrationRepository {
  RegistrationRepository(this._dio);

  final Dio _dio;

  Future<Registration> register(String eventId) async {
    final res = await _dio.post('/registrations/$eventId/register');
    final data = res.data as Map<String, dynamic>;
    return Registration.fromJson(data['registration'] as Map<String, dynamic>);
  }

  Future<List<Registration>> myRegistrations() async {
    final res = await _dio.get('/registrations/me');
    final data = res.data as Map<String, dynamic>;
    final items = data['registrations'] as List;
    return items.map((e) => Registration.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Returns `(isRegistered, isWaitlisted)` for the current user on [eventId].
  Future<(bool, bool)> checkStatus(String eventId) async {
    final res = await _dio.get('/registrations/$eventId/status');
    final data = res.data as Map<String, dynamic>;
    return (data['isRegistered'] as bool? ?? false, data['isWaitlisted'] as bool? ?? false);
  }

  Future<List<Registration>> participantsFor(String eventId) async {
    final res = await _dio.get('/registrations/$eventId/participants');
    final data = res.data as Map<String, dynamic>;
    final items = data['participants'] as List;
    return items.map((e) => Registration.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Registration> checkIn(String eventId, String userId, {String status = 'attended'}) async {
    final res = await _dio.post('/registrations/$eventId/checkin', data: {'userId': userId, 'status': status});
    final data = res.data as Map<String, dynamic>;
    return Registration.fromJson(data['registration'] as Map<String, dynamic>);
  }

  Future<void> cancel(String registrationId) => _dio.delete('/registrations/$registrationId/cancel');
}

@Riverpod(keepAlive: true)
RegistrationRepository registrationRepository(Ref ref) => RegistrationRepository(ref.watch(dioProvider));
