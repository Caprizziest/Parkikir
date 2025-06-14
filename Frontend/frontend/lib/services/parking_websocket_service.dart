// services/parking_websocket_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ParkingWebSocketService {
  static const String _baseUrl = 'ws://localhost:8000/ws/parkiran/';
  WebSocket? _webSocket;
  StreamController<Map<String, dynamic>>? _streamController;
  Timer? _reconnectTimer;
  bool _isConnecting = false;
  bool _shouldReconnect = true;

  // Stream untuk data yang diterima
  Stream<Map<String, dynamic>> get dataStream =>
      _streamController?.stream ?? const Stream.empty();

  // Status koneksi
  bool get isConnected => _webSocket != null;

  Future<void> connect() async {
    if (_isConnecting || isConnected) return;

    _isConnecting = true;
    _shouldReconnect = true;

    try {
      debugPrint('Connecting to WebSocket: $_baseUrl');

      _webSocket = await WebSocket.connect(_baseUrl);
      _streamController ??= StreamController<Map<String, dynamic>>.broadcast();

      debugPrint('WebSocket connected successfully');

      // Listen untuk data yang masuk
      _webSocket!.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
      );

      _isConnecting = false;
      _cancelReconnectTimer();
    } catch (e) {
      debugPrint('WebSocket connection error: $e');
      _isConnecting = false;
      _handleConnectionError();
    }
  }

  void _onData(dynamic data) {
    try {
      debugPrint('Received WebSocket data: $data');

      final Map<String, dynamic> jsonData = json.decode(data.toString());
      _streamController?.add(jsonData);
    } catch (e) {
      debugPrint('Error parsing WebSocket data: $e');
    }
  }

  void _onError(error) {
    debugPrint('WebSocket error: $error');
    _handleConnectionError();
  }

  void _onDone() {
    debugPrint('WebSocket connection closed');
    _webSocket = null;
    _isConnecting = false;

    if (_shouldReconnect) {
      _scheduleReconnect();
    }
  }

  void _handleConnectionError() {
    _webSocket = null;
    _isConnecting = false;

    if (_shouldReconnect) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _cancelReconnectTimer();

    debugPrint('Scheduling reconnect in 5 seconds...');
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (_shouldReconnect && !isConnected) {
        connect();
      }
    });
  }

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  Future<void> disconnect() async {
    _shouldReconnect = false;
    _cancelReconnectTimer();

    await _webSocket?.close();
    _webSocket = null;

    await _streamController?.close();
    _streamController = null;

    debugPrint('WebSocket disconnected');
  }

  // Method untuk mengirim data (jika diperlukan)
  void sendMessage(Map<String, dynamic> message) {
    if (isConnected) {
      _webSocket!.add(json.encode(message));
    } else {
      debugPrint('Cannot send message: WebSocket not connected');
    }
  }
}
