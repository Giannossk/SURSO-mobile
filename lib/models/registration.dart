import 'event.dart';
import 'user.dart';

class Registration {
  const Registration({
    required this.id,
    this.userId,
    this.user,
    this.eventId,
    this.event,
    this.status = 'registered',
    this.qrCodeDataUrl,
    this.paymentStatus,
  });

  final String id;
  final String? userId;
  final User? user;
  final String? eventId;
  final Event? event;
  final String status; // registered, waitlisted, attended, cancelled
  final String? qrCodeDataUrl;
  final String? paymentStatus;

  bool get isWaitlisted => status == 'waitlisted';
  bool get isCancelled => status == 'cancelled';
  bool get isAttended => status == 'attended';

  factory Registration.fromJson(Map<String, dynamic> json) {
    return Registration(
      id: (json['_id'] ?? json['id']).toString(),
      userId: idOf(json['user']),
      user: userOf(json['user']),
      eventId: idOf(json['event']),
      event: json['event'] is Map<String, dynamic> ? Event.fromJson(json['event'] as Map<String, dynamic>) : null,
      status: json['status'] as String? ?? 'registered',
      qrCodeDataUrl: json['qrCodeDataUrl'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
    );
  }
}
