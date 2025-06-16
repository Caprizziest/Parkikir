// payment_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class PaymentService {
  final http.Client client;

  PaymentService({http.Client? client}) : client = client ?? http.Client();
  Future<Map<String, dynamic>> createPayment(int bookingId, int userId) async {
    final url = Uri.parse(ApiConfig.paymentCreateUrl);

    try {
      final response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'booking_id': bookingId,
              'user_id': userId,
            }),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'token': data['token'],
          'redirect_url': data['redirect_url'],
          'order_id': data['order_id'],
          'totalharga': data['totalharga'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['detail'] ?? 'Failed to initiate payment.',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error occurred.'};
    }
  }
}
