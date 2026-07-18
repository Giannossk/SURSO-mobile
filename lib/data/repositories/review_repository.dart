import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_client.dart';
import '../../models/review.dart';

part 'review_repository.g.dart';

class ReviewRepository {
  ReviewRepository(this._dio);

  final Dio _dio;

  Future<List<Review>> listReviews(String eventId) async {
    final res = await _dio.get('/reviews/$eventId');
    final data = res.data as Map<String, dynamic>;
    final items = data['reviews'] as List;
    return items.map((e) => Review.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Review> addReview(String eventId, {required int rating, String? comment}) async {
    final res = await _dio.post('/reviews/$eventId', data: {'rating': rating, 'comment': comment});
    final data = res.data as Map<String, dynamic>;
    return Review.fromJson(data['review'] as Map<String, dynamic>);
  }
}

@Riverpod(keepAlive: true)
ReviewRepository reviewRepository(Ref ref) => ReviewRepository(ref.watch(dioProvider));
