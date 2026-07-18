// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(registrationRepository)
final registrationRepositoryProvider = RegistrationRepositoryProvider._();

final class RegistrationRepositoryProvider
    extends
        $FunctionalProvider<
          RegistrationRepository,
          RegistrationRepository,
          RegistrationRepository
        >
    with $Provider<RegistrationRepository> {
  RegistrationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registrationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registrationRepositoryHash();

  @$internal
  @override
  $ProviderElement<RegistrationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RegistrationRepository create(Ref ref) {
    return registrationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegistrationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegistrationRepository>(value),
    );
  }
}

String _$registrationRepositoryHash() =>
    r'ec33a0b3a61311d742c0770c359356bce0abf207';
