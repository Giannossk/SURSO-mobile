class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isBlocked = false,
    this.points = 0,
    this.interests = const [],
    this.avatarUrl,
    this.phoneNumber,
  });

  final String id;
  final String name;
  final String email;
  final String role; // customer/attendee, organizer, admin
  final bool isBlocked;
  final int points;
  final List<String> interests;
  final String? avatarUrl;
  final String? phoneNumber;

  bool get isOrganizer => role == 'organizer';
  bool get isAdmin => role == 'admin';
  bool get isCustomer => role == 'customer' || role == 'attendee';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['_id'] ?? json['id']).toString(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'customer',
      isBlocked: json['isBlocked'] as bool? ?? false,
      points: (json['points'] as num?)?.toInt() ?? 0,
      interests: (json['interests'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      avatarUrl: json['avatarUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'role': role,
        'isBlocked': isBlocked,
        'points': points,
        'interests': interests,
        'avatarUrl': avatarUrl,
        'phoneNumber': phoneNumber,
      };

  User copyWith({
    String? name,
    String? email,
    String? role,
    bool? isBlocked,
    int? points,
    List<String>? interests,
    String? avatarUrl,
    String? phoneNumber,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isBlocked: isBlocked ?? this.isBlocked,
      points: points ?? this.points,
      interests: interests ?? this.interests,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

/// Extracts a Mongo-style id whether [json] is a raw id string or a
/// populated `{ _id, ... }` document — the backend does both depending on
/// whether the field was `.populate()`d.
String? idOf(dynamic json) {
  if (json == null) return null;
  if (json is String) return json;
  if (json is Map) return (json['_id'] ?? json['id'])?.toString();
  return null;
}

/// Parses [json] into a [User] only when it's a populated document; returns
/// null when it's just a raw id string.
User? userOf(dynamic json) {
  if (json is Map<String, dynamic>) return User.fromJson(json);
  return null;
}
