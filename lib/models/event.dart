import 'user.dart';

class Event {
  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.location,
    required this.capacity,
    this.registeredCount = 0,
    this.organizerId,
    this.organizer,
    this.coOrganizerIds = const [],
    this.posterUrl,
    this.status = 'pending',
    this.tags = const [],
    this.averageRating = 0,
    this.price = 0,
    this.isFree = true,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime date;
  final String location;
  final int capacity;
  final int registeredCount;
  final String? organizerId;
  final User? organizer;
  final List<String> coOrganizerIds;
  final String? posterUrl;
  final String status; // pending, approved, rejected
  final List<String> tags;
  final double averageRating;
  final num price;
  final bool isFree;

  bool get isFull => registeredCount >= capacity;
  int get spotsLeft => (capacity - registeredCount).clamp(0, capacity);

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: (json['_id'] ?? json['id']).toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      location: json['location'] as String? ?? '',
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      registeredCount: (json['registeredCount'] as num?)?.toInt() ?? 0,
      organizerId: idOf(json['organizer']),
      organizer: userOf(json['organizer']),
      coOrganizerIds: (json['coOrganizers'] as List?)?.map((e) => idOf(e) ?? '').where((e) => e.isNotEmpty).toList() ?? const [],
      posterUrl: json['posterUrl'] as String?,
      status: json['status'] as String? ?? 'pending',
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
      price: (json['price'] as num?) ?? 0,
      isFree: json['isFree'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'description': description,
        'category': category,
        'date': date.toIso8601String(),
        'location': location,
        'capacity': capacity,
        'registeredCount': registeredCount,
        'organizer': organizerId,
        'coOrganizers': coOrganizerIds,
        'posterUrl': posterUrl,
        'status': status,
        'tags': tags,
        'averageRating': averageRating,
        'price': price,
        'isFree': isFree,
      };
}
