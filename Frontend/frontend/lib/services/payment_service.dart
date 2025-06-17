// payment_service.dart - Updated with authentication
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../services/token_service.dart';

class PaymentService {
  final http.Client client;
  final TokenService tokenService;

  PaymentService({
    http.Client? client,
    TokenService? tokenService,
  }) : client = client ?? http.Client(),
       tokenService = tokenService ?? TokenService();

  Future<Map<String, dynamic>> createPayment(int bookingId, int userId) async {
    final url = Uri.parse(ApiConfig.paymentCreateUrl);

    try {
      // Get access token from TokenService
      final accessToken = await tokenService.getAccessToken();
      
      if (accessToken == null) {
        return {
          'success': false,
          'message': 'Authentication required. Please login first.',
        };
      }

      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken', // Add authentication header
            },
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
      } else if (response.statusCode == 401) {
        // Handle unauthorized - token might be expired
        return {
          'success': false,
          'message': 'Session expired. Please login again.',
          'code': 'UNAUTHORIZED',
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['detail'] ?? 'Failed to initiate payment.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error occurred: ${e.toString()}',
      };
    }
  }
}