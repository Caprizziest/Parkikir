import '../services/payment_service.dart';

class PaymentRepository {
  final PaymentService paymentService;

  PaymentRepository({required this.paymentService});

  Future<Map<String, dynamic>> createPayment(int bookingId, int userId) async {
    final result = await paymentService.createPayment(bookingId, userId);
    return result;
  }
}