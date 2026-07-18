import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_client.dart';
import '../../models/event.dart';

part 'event_repository.g.dart';

/// Form fields for creating/updating an event. Mirrors the body
/// `POST/PUT /api/events` expects — `tags` must arrive as a JSON-encoded
/// string because multipart fields are text-only (`eventController.js`
/// does `JSON.parse(req.body.tags)`).
class EventDraft {
  const EventDraft({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.location,
    required this.capacity,
    this.price = 0,
    this.isFree = true,
    this.tags = const [],
  });

  final String title;
  final String description;
  final String category;
  final DateTime date;
  final String location;
  final int capacity;
  final num price;
  final bool isFree;
  final List<String> tags;

  Future<FormData> toFormData({String? posterPath}) async {
    return FormData.fromMap({
      'title': title,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
      'location': location,
      'capacity': capacity.toString(),
      'price': price.toString(),
      'isFree': isFree.toString(),
      'tags': jsonEncode(tags),
      if (posterPath != null) 'poster': await MultipartFile.fromFile(posterPath),
    });
  }
}

class EventRepository {
  EventRepository(this._dio);

  final Dio _dio;

  /// [q] searches by title (backend param name is `q`, not `search`).
  Future<List<Event>> listEvents({String? q, String? category, String? status, String? organizer}) async {
    final res = await _dio.get('/events', queryParameters: {
      'q': ?q,
      'category': ?category,
      'status': ?status,
      'organizer': ?organizer,
    });
    final data = res.data;
    final items = (data is Map ? data['events'] ?? data['data'] : data) as List;
    return items.map((e) => Event.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<String>> popularTags() async {
    final res = await _dio.get('/events/tags/popular');
    final data = res.data;
    final items = (data is Map ? data['tags'] ?? data['data'] : data) as List;
    return items.map((e) => e.toString()).toList();
  }

  Future<Event> getEvent(String id) async {
    final res = await _dio.get('/events/$id');
    final data = res.data;
    return Event.fromJson((data is Map && data['event'] != null ? data['event'] : data) as Map<String, dynamic>);
  }

  Future<Event> createEvent(EventDraft draft, {String? posterPath}) async {
    final form = await draft.toFormData(posterPath: posterPath);
    final res = await _dio.post('/events', data: form);
    final data = res.data;
    return Event.fromJson((data is Map && data['event'] != null ? data['event'] : data) as Map<String, dynamic>);
  }

  Future<Event> updateEvent(String id, EventDraft draft, {String? posterPath}) async {
    final form = await draft.toFormData(posterPath: posterPath);
    final res = await _dio.put('/events/$id', data: form);
    final data = res.data;
    return Event.fromJson((data is Map && data['event'] != null ? data['event'] : data) as Map<String, dynamic>);
  }

  Future<void> deleteEvent(String id) => _dio.delete('/events/$id');

  Future<void> sendReminders(String id) => _dio.post('/events/$id/remind');

  Future<void> addCoOrganizer(String eventId, String email) =>
      _dio.post('/events/$eventId/co-organizers', data: {'email': email});

  Future<void> removeCoOrganizer(String eventId, String userId) =>
      _dio.delete('/events/$eventId/co-organizers/$userId');
}

@Riverpod(keepAlive: true)
EventRepository eventRepository(Ref ref) => EventRepository(ref.watch(dioProvider));
