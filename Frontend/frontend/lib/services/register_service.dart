import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/register_model.dart';

class RegisterService {
  final String baseUrl;

  RegisterService({required this.baseUrl});

  Future<Map<String, dynamic>> register(RegisterModel model) async {
    final url = Uri.parse('$baseUrl/register/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 201) {
      return {'success': true, 'message': 'User registered successfully'};
    } else {
      return {'success': false, 'message': jsonDecode(response.body)};
    }
  }
}
