// booking_repository.dart
import '../services/booking_service.dart';
import '../model/booking_model.dart';

class BookingRepository {
  final BookingService bookingService;

  BookingRepository({required this.bookingService});

  Future<Map<String, dynamic>> createBooking({
    required String slotId,
    required double totalPrice,
  }) async {
    final result = await bookingService.createBooking(
      slotId: slotId,
      totalPrice: totalPrice,
    );

    if (result['success'] == true && result['booking'] != null) {
      try {
        final booking = BookingModel.fromJson(result['booking']['data']);
        return {
          'success': true,
          'booking': booking,
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Failed to parse booking data: ${e.toString()}',
        };
      }
    }

    return result;
  }
}