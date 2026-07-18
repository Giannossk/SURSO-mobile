import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/review_repository.dart';
import '../../models/review.dart';

part 'reviews_provider.g.dart';

@riverpod
Future<List<Review>> eventReviews(Ref ref, String eventId) {
  return ref.watch(reviewRepositoryProvider).listReviews(eventId);
}

@riverpod
class ReviewActions extends _$ReviewActions {
  @override
  void build() {}

  Future<void> add(String eventId, {required int rating, String? comment}) async {
    await ref.read(reviewRepositoryProvider).addReview(eventId, rating: rating, comment: comment);
    ref.invalidate(eventReviewsProvider(eventId));
  }
}
