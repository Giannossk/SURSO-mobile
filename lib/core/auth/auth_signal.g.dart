// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_signal.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bumped whenever something outside the auth flow itself (e.g. a 401
/// response) needs to force the app back to a logged-out state. Kept
/// separate from the auth feature so `core/network` doesn't have to
/// depend on `features/auth`.

@ProviderFor(AuthSignal)
final authSignalProvider = AuthSignalProvider._();

/// Bumped whenever something outside the auth flow itself (e.g. a 401
/// response) needs to force the app back to a logged-out state. Kept
/// separate from the auth feature so `core/network` doesn't have to
/// depend on `features/auth`.
final class AuthSignalProvider extends $NotifierProvider<AuthSignal, int> {
  /// Bumped whenever something outside the auth flow itself (e.g. a 401
  /// response) needs to force the app back to a logged-out state. Kept
  /// separate from the auth feature so `core/network` doesn't have to
  /// depend on `features/auth`.
  AuthSignalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSignalProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSignalHash();

  @$internal
  @override
  AuthSignal create() => AuthSignal();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$authSignalHash() => r'8eb070cdeb7741ef87f5556f9b9bdb6ca2d3c97f';

/// Bumped whenever something outside the auth flow itself (e.g. a 401
/// response) needs to force the app back to a logged-out state. Kept
/// separate from the auth feature so `core/network` doesn't have to
/// depend on `features/auth`.

abstract class _$AuthSignal extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
