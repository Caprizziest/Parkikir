// viewmodels/bookingparkir_viewmodel.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/slot_parkir_model.dart';
import '../repository/parking_repository.dart';

enum ParkingState {
  initial,
  loading,
  connected,
  disconnected,
  error,
}

// Define a more comprehensive state for your ViewModel
class BookingparkirDataState {
  final ParkingState status;
  final List<SlotParkir> slots;
  final String? errorMessage;
  // Add other stats if you want them to be part of the main state
  final int totalSlots;
  final int availableSlots;

  BookingparkirDataState({
    required this.status,
    this.slots = const [],
    this.errorMessage,
    this.totalSlots = 0,
    this.availableSlots = 0,
  });

  BookingparkirDataState copyWith({
    ParkingState? status,
    List<SlotParkir>? slots,
    String? errorMessage,
    int? totalSlots,
    int? availableSlots,
  }) {
    return BookingparkirDataState(
      status: status ?? this.status,
      slots: slots ?? this.slots,
      errorMessage: errorMessage ?? this.errorMessage,
      totalSlots: totalSlots ?? this.totalSlots,
      availableSlots: availableSlots ?? this.availableSlots,
    );
  }
}

class BookingparkirViewModel extends StateNotifier<BookingparkirDataState> {
  final ParkingRepository _repository;
  StreamSubscription<List<SlotParkir>>? _slotsSubscription;

  BookingparkirViewModel({ParkingRepository? repository})
      : _repository = repository ?? ParkingRepository(),
        super(BookingparkirDataState(
            status: ParkingState.initial)); // Initial state

  // Getters now access properties of the current state object
  List<SlotParkir> get slots => state.slots;
  String? get errorMessage => state.errorMessage;
  bool get isConnected => _repository.isConnected;
  bool get isLoading => state.status == ParkingState.loading;
  bool get hasError => state.status == ParkingState.error;

  int get totalSlots => state.totalSlots;
  int get availableSlots => state.availableSlots;
  // You'll need to calculate unavailableSlots/occupancyRate based on totalSlots and availableSlots
  int get unavailableSlots => totalSlots - availableSlots;
  double get occupancyRate =>
      totalSlots > 0 ? (unavailableSlots / totalSlots) * 100 : 0.0;

  Future<void> initializeConnection() async {
    if (state.status == ParkingState.loading) return;

    state = state.copyWith(status: ParkingState.loading, errorMessage: null);

    try {
      await _repository.startConnection();

      _slotsSubscription = _repository.slotsStream.listen(
        _onSlotsUpdate,
        onError: _onStreamError,
        onDone: _onStreamDone,
      );

      state = state.copyWith(status: ParkingState.connected);
    } catch (e) {
      state = state.copyWith(
        status: ParkingState.error,
        errorMessage: 'Failed to connect: ${e.toString()}',
      );
      debugPrint('Connection error: $e');
    }
  }

  Future<void> disconnect() async {
    try {
      await _slotsSubscription?.cancel();
      _slotsSubscription = null;
      await _repository.stopConnection();
      state = state.copyWith(status: ParkingState.disconnected);
    } catch (e) {
      debugPrint('Disconnect error: $e');
    }
  }

  Future<void> reconnect() async {
    await disconnect();
    await Future.delayed(const Duration(seconds: 1));
    await initializeConnection();
  }

  void _onSlotsUpdate(List<SlotParkir> newSlots) {
    final newTotal = newSlots.length;
    final newAvailable = newSlots.where((slot) => slot.isAvailable).length;

    state = state.copyWith(
      slots: newSlots,
      status: ParkingState.connected, // Ensure status is connected
      totalSlots: newTotal,
      availableSlots: newAvailable,
    );
  }

  void _onStreamError(error) {
    state = state.copyWith(
      status: ParkingState.error,
      errorMessage: 'Stream error: ${error.toString()}',
    );
    debugPrint('Stream error: $error');
  }

  void _onStreamDone() {
    state = state.copyWith(status: ParkingState.disconnected);
    debugPrint('Stream completed');
  }

  // No need for _updateStatistics as data is updated directly in _onSlotsUpdate
  // void _updateStatistics() { ... }

  SlotParkir? getSlotById(String slotId) {
    try {
      return state.slots.firstWhere((slot) => slot.slotparkirid == slotId);
    } catch (e) {
      return null;
    }
  }

  List<SlotParkir> getAvailableSlots() {
    return state.slots.where((slot) => slot.isAvailable).toList();
  }

  List<SlotParkir> getUnavailableSlots() {
    return state.slots.where((slot) => !slot.isAvailable).toList();
  }

  List<SlotParkir> getSlotsBySection(String section) {
    return state.slots
        .where((slot) =>
            slot.slotparkirid.toLowerCase().startsWith(section.toLowerCase()))
        .toList();
  }

  bool isSlotAvailable(String slotId) {
    final slot = getSlotById(slotId);
    return slot?.isAvailable ?? false;
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
    if (state.status == ParkingState.error) {
      state = state.copyWith(status: ParkingState.disconnected);
    }
  }

  @override
  void dispose() {
    _slotsSubscription?.cancel();
    _repository.stopConnection();
    super.dispose();
  }
}

final bookingparkirViewModelProvider =
    StateNotifierProvider<BookingparkirViewModel, BookingparkirDataState>(
  (ref) => BookingparkirViewModel(),
);

// Update how you access slots and error messages in bookingparkir.dart
// For example, in bookingparkir.dart, you'd watch the main provider:
// final bookingparkirData = ref.watch(bookingparkirViewModelProvider);
// final slots = bookingparkirData.slots;
// final errorMessage = bookingparkirData.errorMessage;
// final parkingState = bookingparkirData.status;

// You can remove the separate `parkingSlotsProvider` and `parkingErrorMessageProvider`
// if you prefer to get everything from the main ViewModel's state object.
// Or keep them if you want more granular rebuilds based on just slots or just error messages.
// If you keep them, they should look like this:
final parkingSlotsProvider = Provider<List<SlotParkir>>((ref) {
  return ref.watch(
      bookingparkirViewModelProvider.select((dataState) => dataState.slots));
});

final parkingErrorMessageProvider = Provider<String?>((ref) {
  return ref.watch(bookingparkirViewModelProvider
      .select((dataState) => dataState.errorMessage));
});
final totalSlotsProvider = Provider<int>((ref) {
  final bookingparkirViewModel =
      ref.watch(bookingparkirViewModelProvider.notifier);
  return bookingparkirViewModel.totalSlots;
});

final availableSlotsProvider = Provider<int>((ref) {
  final bookingparkirViewModel =
      ref.watch(bookingparkirViewModelProvider.notifier);
  return bookingparkirViewModel.availableSlots;
});

final unavailableSlotsProvider = Provider<int>((ref) {
  final bookingparkirViewModel =
      ref.watch(bookingparkirViewModelProvider.notifier);
  return bookingparkirViewModel.unavailableSlots;
});

final occupancyRateProvider = Provider<double>((ref) {
  final bookingparkirViewModel =
      ref.watch(bookingparkirViewModelProvider.notifier);
  return bookingparkirViewModel.occupancyRate;
});
