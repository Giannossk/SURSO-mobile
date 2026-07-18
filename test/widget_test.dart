import 'package:flutter_test/flutter_test.dart';
import 'package:surso/models/user.dart';
import 'package:surso/models/event.dart';

void main() {
  test('User.fromJson parses both _id and id, and role helpers work', () {
    final user = User.fromJson({
      '_id': 'u1',
      'name': 'Ada Lovelace',
      'email': 'ada@example.com',
      'role': 'organizer',
    });

    expect(user.id, 'u1');
    expect(user.isOrganizer, isTrue);
    expect(user.isAdmin, isFalse);
  });

  test('Event.fromJson resolves organizer as a populated User or a raw id', () {
    final populated = Event.fromJson({
      '_id': 'e1',
      'title': 'Flutter Meetup',
      'description': 'desc',
      'category': 'tech',
      'date': '2026-08-01T10:00:00.000Z',
      'location': 'Athens',
      'capacity': 100,
      'organizer': {'_id': 'u1', 'name': 'Ada', 'email': 'a@e.com', 'role': 'organizer'},
    });
    expect(populated.organizerId, 'u1');
    expect(populated.organizer?.name, 'Ada');

    final idOnly = Event.fromJson({
      '_id': 'e2',
      'title': 'Another Event',
      'description': 'desc',
      'category': 'tech',
      'date': '2026-08-01T10:00:00.000Z',
      'location': 'Athens',
      'capacity': 50,
      'organizer': 'u2',
    });
    expect(idOnly.organizerId, 'u2');
    expect(idOnly.organizer, isNull);
  });
}
