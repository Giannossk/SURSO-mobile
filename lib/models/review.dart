import 'user.dart';

class Review {
  const Review({
    required this.id,
    required this.rating,
    this.comment,
    this.user,
    this.createdAt,
  });

  final String id;
  final int rating;
  final String? comment;
  final User? user;
  final DateTime? createdAt;

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: (json['_id'] ?? json['id']).toString(),
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String?,
      user: userOf(json['user']),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
    );
  }
}
