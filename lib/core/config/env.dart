import 'dart:io' show Platform;

/// API base URL, overridable at build/run time with
/// `--dart-define=API_BASE_URL=https://api.example.com`.
class Env {
  static const _override = String.fromEnvironment('API_BASE_URL');

  /// Backend base URL (no trailing slash), e.g. `http://10.0.2.2:5050`.
  static String get apiBaseUrl {
    if (_override.isNotEmpty) return _override;
    // 10.0.2.2 is the Android emulator's alias for the host machine's
    // localhost; iOS simulator can reach the host via localhost directly.
    if (Platform.isAndroid) return 'http://10.0.2.2:5050';
    return 'http://localhost:5050';
  }

  static String get apiUrl => '$apiBaseUrl/api';
}
