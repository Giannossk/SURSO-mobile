import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_client.dart';
import '../../models/event.dart';

part 'user_repository.g.dart';

class UserRepository {
  UserRepository(this._dio);

  final Dio _dio;

  /// Toggles the saved/favorited state of [eventId]; returns the updated
  /// list of saved event ids.
  Future<List<String>> toggleSaveEvent(String eventId) async {
    final res = await _dio.post('/users/save-event/$eventId');
    final data = res.data as Map<String, dynamic>;
    return (data['savedEvents'] as List).map((e) => e.toString()).toList();
  }

  Future<List<Event>> savedEvents() async {
    final res = await _dio.get('/users/saved-events');
    final data = res.data as Map<String, dynamic>;
    final items = data['savedEvents'] as List;
    return items.map((e) => Event.fromJson(e as Map<String, dynamic>)).toList();
  }
}

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) => UserRepository(ref.watch(dioProvider));
