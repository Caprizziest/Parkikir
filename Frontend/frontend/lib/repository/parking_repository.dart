// repositories/parking_repository.dart
import 'dart:async';
import '../services/parking_websocket_service.dart';
import '../model/slot_parkir_model.dart';

class ParkingRepository {
  final ParkingWebSocketService _webSocketService;

  ParkingRepository({ParkingWebSocketService? webSocketService})
      : _webSocketService = webSocketService ?? ParkingWebSocketService();

  // Stream untuk mendapatkan data slot parkir
  Stream<List<SlotParkir>> get slotsStream =>
      _webSocketService.dataStream.map(_parseSlotParkir).handleError((error) {
        print('Error in parking repository stream: $error');
        return <SlotParkir>[];
      });

  // Status koneksi WebSocket
  bool get isConnected => _webSocketService.isConnected;

  // Mulai koneksi WebSocket
  Future<void> startConnection() async {
    try {
      await _webSocketService.connect();
    } catch (e) {
      print('Failed to start WebSocket connection: $e');
      rethrow;
    }
  }

  // Hentikan koneksi WebSocket
  Future<void> stopConnection() async {
    try {
      await _webSocketService.disconnect();
    } catch (e) {
      print('Failed to stop WebSocket connection: $e');
    }
  }

  // Parse data JSON menjadi list SlotParkir
  List<SlotParkir> _parseSlotParkir(Map<String, dynamic> data) {
    try {
      // Cek apakah data memiliki struktur yang benar
      if (data['type'] == 'all_slotparkir' && data['data'] != null) {
        final List<dynamic> slotsData = data['data'] as List<dynamic>;

        return slotsData
            .map((slotData) =>
                SlotParkir.fromJson(slotData as Map<String, dynamic>))
            .toList();
      }

      return <SlotParkir>[];
    } catch (e) {
      print('Error parsing slot parkir data: $e');
      return <SlotParkir>[];
    }
  }

  // Method untuk mendapatkan slot berdasarkan ID (opsional)
  SlotParkir? getSlotById(List<SlotParkir> slots, String slotId) {
    try {
      return slots.firstWhere((slot) => slot.slotparkirid == slotId);
    } catch (e) {
      return null;
    }
  }

  // Method untuk mendapatkan slot yang tersedia
  List<SlotParkir> getAvailableSlots(List<SlotParkir> slots) {
    return slots.where((slot) => slot.isAvailable).toList();
  }

  // Method untuk mendapatkan slot yang tidak tersedia
  List<SlotParkir> getUnavailableSlots(List<SlotParkir> slots) {
    return slots.where((slot) => !slot.isAvailable).toList();
  }

  // Method untuk menghitung statistik slot
  Map<String, int> getSlotStatistics(List<SlotParkir> slots) {
    final available = getAvailableSlots(slots).length;
    final unavailable = getUnavailableSlots(slots).length;
    final total = slots.length;

    return {
      'total': total,
      'available': available,
      'unavailable': unavailable,
    };
  }
}
