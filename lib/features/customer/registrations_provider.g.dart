// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registrations_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myRegistrations)
final myRegistrationsProvider = MyRegistrationsProvider._();

final class MyRegistrationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Registration>>,
          List<Registration>,
          FutureOr<List<Registration>>
        >
    with
        $FutureModifier<List<Registration>>,
        $FutureProvider<List<Registration>> {
  MyRegistrationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myRegistrationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myRegistrationsHash();

  @$internal
  @override
  $FutureProviderElement<List<Registration>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Registration>> create(Ref ref) {
    return myRegistrations(ref);
  }
}

String _$myRegistrationsHash() => r'ed7d8465fac6bfcf37e56d0fa55b1f7db6fc66c0';

@ProviderFor(registrationById)
final registrationByIdProvider = RegistrationByIdFamily._();

final class RegistrationByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Registration?>,
          Registration?,
          FutureOr<Registration?>
        >
    with $FutureModifier<Registration?>, $FutureProvider<Registration?> {
  RegistrationByIdProvider._({
    required RegistrationByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'registrationByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$registrationByIdHash();

  @override
  String toString() {
    return r'registrationByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Registration?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Registration?> create(Ref ref) {
    final argument = this.argument as String;
    return registrationById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RegistrationByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$registrationByIdHash() => r'4f704147bc4bc00953f4b9be6e56f04baccaca3b';

final class RegistrationByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Registration?>, String> {
  RegistrationByIdFamily._()
    : super(
        retry: null,
        name: r'registrationByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RegistrationByIdProvider call(String id) =>
      RegistrationByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'registrationByIdProvider';
}

@ProviderFor(RegistrationActions)
final registrationActionsProvider = RegistrationActionsProvider._();

final class RegistrationActionsProvider
    extends $NotifierProvider<RegistrationActions, void> {
  RegistrationActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registrationActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registrationActionsHash();

  @$internal
  @override
  RegistrationActions create() => RegistrationActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$registrationActionsHash() =>
    r'607609b4addd0bbd02fd0ff4ca9fef662b5e63d9';

abstract class _$RegistrationActions extends $Notifier<void> {
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
