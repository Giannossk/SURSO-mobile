import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/auth_signal.dart';
import '../config/env.dart';
import '../storage/token_storage.dart';

part 'dio_client.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final storage = ref.watch(tokenStorageProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.readToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await storage.deleteToken();
          ref.read(authSignalProvider.notifier).forceLogout();
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}

/// Extracts a human-readable message from a failed [DioException], falling
/// back to a generic message when the backend didn't send one.
String dioErrorMessage(DioException e, {String fallback = 'Something went wrong. Please try again.'}) {
  final data = e.response?.data;
  if (data is Map && data['message'] is String) {
    return data['message'] as String;
  }
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.connectionError) {
    return 'Could not reach the server. Check your connection and try again.';
  }
  return fallback;
}
