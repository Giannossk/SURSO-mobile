import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../config/env.dart';

part 'socket_service.g.dart';

/// Thin wrapper around the single app-wide Socket.IO connection. Connect once
/// after login (`connect(userId)`), listen for events via [socket], and
/// disconnect on logout. Mirrors the backend contract in
/// `backend/src/services/socket.js`: emits `user:join`/`event:join`/`event:leave`,
/// listens for `registration:count`, `notification:new`, `announcement`.
class SocketService {
  io.Socket? _socket;
  final _notificationController = StreamController<Map<String, dynamic>>.broadcast();

  io.Socket? get socket => _socket;

  /// Emits each `notification:new` payload received from the server.
  Stream<Map<String, dynamic>> get onNotification => _notificationController.stream;

  void connect(String userId) {
    if (_socket != null) return;
    final socket = io.io(
      Env.apiBaseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    _socket = socket;
    socket.connect();
    socket.onConnect((_) => socket.emit('user:join', {'userId': userId}));
    socket.on('notification:new', (data) {
      if (data is Map) _notificationController.add(Map<String, dynamic>.from(data));
    });
  }

  void joinEvent(String eventId) => _socket?.emit('event:join', {'eventId': eventId});

  void leaveEvent(String eventId) => _socket?.emit('event:leave', {'eventId': eventId});

  void disconnect() {
    _socket?.dispose();
    _socket = null;
  }
}

@Riverpod(keepAlive: true)
SocketService socketService(Ref ref) => SocketService();
