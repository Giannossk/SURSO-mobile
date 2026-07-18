import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_client.dart';
import '../../core/storage/token_storage.dart';
import '../../models/user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Future<User> login({required String email, required String password}) async {
    final res = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    return _persistAndParse(res.data as Map<String, dynamic>);
  }

  Future<User> signup({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final res = await _dio.post('/auth/signup', data: {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    });
    return _persistAndParse(res.data as Map<String, dynamic>);
  }

  Future<User> me() async {
    final res = await _dio.get('/auth/me');
    final data = res.data as Map<String, dynamic>;
    return User.fromJson((data['user'] ?? data) as Map<String, dynamic>);
  }

  Future<User> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    final res = await _dio.put('/auth/profile', data: {
      'name': ?name,
      'email': ?email,
      'phoneNumber': ?phoneNumber,
      'avatarUrl': ?avatarUrl,
    });
    final data = res.data as Map<String, dynamic>;
    return User.fromJson((data['user'] ?? data) as Map<String, dynamic>);
  }

  Future<void> logout() => _tokenStorage.deleteToken();

  Future<User> _persistAndParse(Map<String, dynamic> data) async {
    final token = data['token'] as String?;
    if (token != null) {
      await _tokenStorage.writeToken(token);
    }
    return User.fromJson((data['user'] ?? data) as Map<String, dynamic>);
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(dioProvider), ref.watch(tokenStorageProvider));
}
