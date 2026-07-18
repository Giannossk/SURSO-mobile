// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pendingEvents)
final pendingEventsProvider = PendingEventsProvider._();

final class PendingEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Event>>,
          List<Event>,
          FutureOr<List<Event>>
        >
    with $FutureModifier<List<Event>>, $FutureProvider<List<Event>> {
  PendingEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingEventsHash();

  @$internal
  @override
  $FutureProviderElement<List<Event>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Event>> create(Ref ref) {
    return pendingEvents(ref);
  }
}

String _$pendingEventsHash() => r'8c25aecc9a30621b05cb87761c09f3c687150b1b';

@ProviderFor(allEventsAdmin)
final allEventsAdminProvider = AllEventsAdminProvider._();

final class AllEventsAdminProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Event>>,
          List<Event>,
          FutureOr<List<Event>>
        >
    with $FutureModifier<List<Event>>, $FutureProvider<List<Event>> {
  AllEventsAdminProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allEventsAdminProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allEventsAdminHash();

  @$internal
  @override
  $FutureProviderElement<List<Event>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Event>> create(Ref ref) {
    return allEventsAdmin(ref);
  }
}

String _$allEventsAdminHash() => r'd09a3c468866c6a9490ab924e40b8b1891e17f1a';

@ProviderFor(allUsers)
final allUsersProvider = AllUsersProvider._();

final class AllUsersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<User>>,
          List<User>,
          FutureOr<List<User>>
        >
    with $FutureModifier<List<User>>, $FutureProvider<List<User>> {
  AllUsersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allUsersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allUsersHash();

  @$internal
  @override
  $FutureProviderElement<List<User>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<User>> create(Ref ref) {
    return allUsers(ref);
  }
}

String _$allUsersHash() => r'b198c24b2570f9d2c0ef76cfa8302dffd29dde26';

@ProviderFor(AdminActions)
final adminActionsProvider = AdminActionsProvider._();

final class AdminActionsProvider extends $NotifierProvider<AdminActions, void> {
  AdminActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminActionsHash();

  @$internal
  @override
  AdminActions create() => AdminActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$adminActionsHash() => r'20095640c4f8fe2d8af1099fc14838ae27f5a82d';

abstract class _$AdminActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
