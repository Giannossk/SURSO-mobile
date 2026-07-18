import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_signal.g.dart';

/// Bumped whenever something outside the auth flow itself (e.g. a 401
/// response) needs to force the app back to a logged-out state. Kept
/// separate from the auth feature so `core/network` doesn't have to
/// depend on `features/auth`.
@Riverpod(keepAlive: true)
class AuthSignal extends _$AuthSignal {
  @override
  int build() => 0;

  void forceLogout() => state++;
}
