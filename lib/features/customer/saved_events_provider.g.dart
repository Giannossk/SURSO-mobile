// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_events_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(savedEvents)
final savedEventsProvider = SavedEventsProvider._();

final class SavedEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Event>>,
          List<Event>,
          FutureOr<List<Event>>
        >
    with $FutureModifier<List<Event>>, $FutureProvider<List<Event>> {
  SavedEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedEventsHash();

  @$internal
  @override
  $FutureProviderElement<List<Event>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Event>> create(Ref ref) {
    return savedEvents(ref);
  }
}

String _$savedEventsHash() => r'109ae6ad41fa450f7d36eb1f7e697ca44277b00b';

@ProviderFor(SaveEventAction)
final saveEventActionProvider = SaveEventActionProvider._();

final class SaveEventActionProvider
    extends $NotifierProvider<SaveEventAction, void> {
  SaveEventActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveEventActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveEventActionHash();

  @$internal
  @override
  SaveEventAction create() => SaveEventAction();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$saveEventActionHash() => r'2869420ccd3138e70c5124c996407097335bca3c';

abstract class _$SaveEventAction extends $Notifier<void> {
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
