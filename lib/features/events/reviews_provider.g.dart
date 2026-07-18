// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(eventReviews)
final eventReviewsProvider = EventReviewsFamily._();

final class EventReviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Review>>,
          List<Review>,
          FutureOr<List<Review>>
        >
    with $FutureModifier<List<Review>>, $FutureProvider<List<Review>> {
  EventReviewsProvider._({
    required EventReviewsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventReviewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventReviewsHash();

  @override
  String toString() {
    return r'eventReviewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Review>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Review>> create(Ref ref) {
    final argument = this.argument as String;
    return eventReviews(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EventReviewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventReviewsHash() => r'f48581913ef7bb531518f7551a3b9f2231c211be';

final class EventReviewsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Review>>, String> {
  EventReviewsFamily._()
    : super(
        retry: null,
        name: r'eventReviewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EventReviewsProvider call(String eventId) =>
      EventReviewsProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventReviewsProvider';
}

@ProviderFor(ReviewActions)
final reviewActionsProvider = ReviewActionsProvider._();

final class ReviewActionsProvider
    extends $NotifierProvider<ReviewActions, void> {
  ReviewActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewActionsHash();

  @$internal
  @override
  ReviewActions create() => ReviewActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$reviewActionsHash() => r'85e8a5bfb5700f77967381ec746ae23e2d470154';

abstract class _$ReviewActions extends $Notifier<void> {
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
