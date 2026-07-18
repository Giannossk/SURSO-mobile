// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(socketNotificationStream)
final socketNotificationStreamProvider = SocketNotificationStreamProvider._();

final class SocketNotificationStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          Stream<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $StreamProvider<Map<String, dynamic>> {
  SocketNotificationStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socketNotificationStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socketNotificationStreamHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, dynamic>> create(Ref ref) {
    return socketNotificationStream(ref);
  }
}

String _$socketNotificationStreamHash() =>
    r'3c24c1102f6336abb59cf8ba947e2537ef8acaa0';

@ProviderFor(NotificationsNotifier)
final notificationsProvider = NotificationsNotifierProvider._();

final class NotificationsNotifierProvider
    extends $AsyncNotifierProvider<NotificationsNotifier, NotificationsState> {
  NotificationsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsNotifierHash();

  @$internal
  @override
  NotificationsNotifier create() => NotificationsNotifier();
}

String _$notificationsNotifierHash() =>
    r'b94f3aead6c7cbd4d6e9db81871c6fba36a89443';

abstract class _$NotificationsNotifier
    extends $AsyncNotifier<NotificationsState> {
  FutureOr<NotificationsState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<NotificationsState>, NotificationsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NotificationsState>, NotificationsState>,
              AsyncValue<NotificationsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
