// viewmodels/history_view_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/booking_model.dart';

// Provider untuk HistoryViewModel
final historyViewModelProvider =
    StateNotifierProvider<HistoryViewModel, AsyncValue<List<BookingModel>>>(
  (ref) => HistoryViewModel(),
);

class HistoryViewModel extends StateNotifier<AsyncValue<List<BookingModel>>> {
  HistoryViewModel() : super(AsyncValue.data(_getDummyData()));

  // Data dummy sesuai gambar
  static List<BookingModel> _getDummyData() {
    return [
      BookingModel(
        slotId: 'D1',
        description: "You've Booked slot D1",
        bookingDate: DateTime.now(),
        status: 'booked',
      ),
    ];
  }

  // Refresh data
  Future<void> refreshHistory() async {
    state = AsyncValue.data(_getDummyData());
  }

  // Format tanggal untuk display
  String formatBookingDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return '${difference} days ago';
    }
  }

  // Format deskripsi
  String formatDescription(String description) {
    return description.length > 50
        ? '${description.substring(0, 50)}...'
        : description;
  }

  // Navigasi ke detail history
  void navigateToHistoryDetail(BuildContext context, String slotId) {
    // Implementasi navigasi ke detail
    // context.push('/history-detail/$slotId');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigate to detail for slot $slotId')),
    );
  }

  // Get status color
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'booked':
        return const Color(0xFF4040FF);
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Get status icon
  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'booked':
        return Icons.event_seat;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}
