import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_storage.g.dart';

/// Secure on-device storage for the JWT auth token.
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> writeToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<void> deleteToken() => _storage.delete(key: _tokenKey);
}

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) {
  return TokenStorage(const FlutterSecureStorage());
}
