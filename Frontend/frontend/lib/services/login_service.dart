import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/login_model.dart';

class LoginService {
  final String baseUrl;
  final http.Client client;

  LoginService({
    required this.baseUrl, 
    http.Client? client
  }) : client = client ?? http.Client();


  Future<Map<String, dynamic>> login(LoginModel model) async {
    final url = Uri.parse('$baseUrl/login/');

   try {
      final response = await client.post(  
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );


      // Check if the response is successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'access_token': data['access'],
          'refresh_token': data['refresh']
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['detail'] ?? 'Login failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error'};
    }
  }
}
