// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer_events_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(organizerEvents)
final organizerEventsProvider = OrganizerEventsProvider._();

final class OrganizerEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Event>>,
          List<Event>,
          FutureOr<List<Event>>
        >
    with $FutureModifier<List<Event>>, $FutureProvider<List<Event>> {
  OrganizerEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizerEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizerEventsHash();

  @$internal
  @override
  $FutureProviderElement<List<Event>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Event>> create(Ref ref) {
    return organizerEvents(ref);
  }
}

String _$organizerEventsHash() => r'5e79031cba974c5ae3954a9b4121b3bd465523d3';

@ProviderFor(organizerDashboardStats)
final organizerDashboardStatsProvider = OrganizerDashboardStatsProvider._();

final class OrganizerDashboardStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  OrganizerDashboardStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizerDashboardStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizerDashboardStatsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    return organizerDashboardStats(ref);
  }
}

String _$organizerDashboardStatsHash() =>
    r'59c8eba1791792aaafc03df573dca0c272f6ca82';

@ProviderFor(eventParticipants)
final eventParticipantsProvider = EventParticipantsFamily._();

final class EventParticipantsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Registration>>,
          List<Registration>,
          FutureOr<List<Registration>>
        >
    with
        $FutureModifier<List<Registration>>,
        $FutureProvider<List<Registration>> {
  EventParticipantsProvider._({
    required EventParticipantsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventParticipantsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventParticipantsHash();

  @override
  String toString() {
    return r'eventParticipantsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Registration>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Registration>> create(Ref ref) {
    final argument = this.argument as String;
    return eventParticipants(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EventParticipantsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventParticipantsHash() => r'4cd49a75d5b49e32f2094621713cc5f07c802892';

final class EventParticipantsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Registration>>, String> {
  EventParticipantsFamily._()
    : super(
        retry: null,
        name: r'eventParticipantsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EventParticipantsProvider call(String eventId) =>
      EventParticipantsProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventParticipantsProvider';
}

@ProviderFor(OrganizerEventActions)
final organizerEventActionsProvider = OrganizerEventActionsProvider._();

final class OrganizerEventActionsProvider
    extends $NotifierProvider<OrganizerEventActions, void> {
  OrganizerEventActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizerEventActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizerEventActionsHash();

  @$internal
  @override
  OrganizerEventActions create() => OrganizerEventActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$organizerEventActionsHash() =>
    r'ee7c2cc59a972f8dcb4c370ecec4b9fcaeb18619';

abstract class _$OrganizerEventActions extends $Notifier<void> {
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
