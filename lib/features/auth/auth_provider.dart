import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/auth/auth_signal.dart';
import '../../core/storage/token_storage.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() async {
    // Rebuild (and re-check the stored token) whenever something forces a
    // logout, e.g. a 401 from the API client.
    ref.watch(authSignalProvider);

    final storage = ref.watch(tokenStorageProvider);
    final token = await storage.readToken();
    if (token == null) return const AuthUnauthenticated();

    try {
      final user = await ref.watch(authRepositoryProvider).me();
      return AuthAuthenticated(user);
    } on DioException {
      await storage.deleteToken();
      return const AuthUnauthenticated();
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authRepositoryProvider).login(email: email, password: password);
      return AuthAuthenticated(user);
    });
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authRepositoryProvider).signup(
            name: name,
            email: email,
            password: password,
            role: role,
          );
      return AuthAuthenticated(user);
    });
  }

  Future<void> updateProfile({String? name, String? email, String? phoneNumber, String? avatarUrl}) async {
    final current = state.value;
    if (current is! AuthAuthenticated) return;
    final updated = await ref.read(authRepositoryProvider).updateProfile(
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          avatarUrl: avatarUrl,
        );
    state = AsyncData(AuthAuthenticated(updated));
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(AuthUnauthenticated());
  }
}
