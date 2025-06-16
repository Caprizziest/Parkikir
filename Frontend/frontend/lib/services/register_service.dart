import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/register_model.dart';
import '../config/api_config.dart';

class RegisterService {
  final http.Client client;

  RegisterService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> register(RegisterModel model) async {
    final url = Uri.parse(ApiConfig.registerUrl);

    try {
      final response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(model.toJson()),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'User registered successfully'};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['detail'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error'};
    }
  }
}
