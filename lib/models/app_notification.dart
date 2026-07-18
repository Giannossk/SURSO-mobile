class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.message,
    this.link,
    this.isRead = false,
    this.createdAt,
  });

  final String id;
  final String type; // registration_confirmed, event_approved, event_rejected, waitlist_promoted
  final String message;
  final String? link;
  final bool isRead;
  final DateTime? createdAt;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: (json['_id'] ?? json['id']).toString(),
      type: json['type'] as String? ?? '',
      message: json['message'] as String? ?? '',
      link: json['link'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
    );
  }

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      type: type,
      message: message,
      link: link,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
