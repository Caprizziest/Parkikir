// booking_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../services/token_service.dart';

class BookingService {
  final http.Client client;
  final TokenService tokenService;

  BookingService({
    http.Client? client,
    TokenService? tokenService,
  }) : client = client ?? http.Client(),
        tokenService = tokenService ?? TokenService();

Future<Map<String, dynamic>> createBooking({
  required String slotId,
  required double totalPrice,
}) async {
  final url = Uri.parse('${ApiConfig.baseUrl}/booking/');
  final token = await tokenService.getAccessToken();
  final userId = await tokenService.getUserId();

  if (token == null || userId == null) {
    return {
      'success': false,
      'message': 'User not authenticated',
    };
  }

  try {
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'slotparkir': slotId,
        'user': userId,
        'tanggal': DateTime.now().toString().split(' ')[0], // Outputs: "2025-06-18"
        'status': 'ACTIVE',
        'totalharga': totalPrice.toInt(),
      }),
    );

        print("Raw response body: ${response.body}");
    
    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'booking': data,
      };
    } else {
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['detail'] ?? 'Failed to create booking.',
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