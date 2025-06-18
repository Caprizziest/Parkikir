import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';
import '../config/api_config.dart';
import 'token_storage.dart';

class UserService {
  final TokenStorage _tokenStorage;

  UserService(this._tokenStorage);

  Future<UserModel> fetchUserById(int userId) async {
    final token = await _tokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    final response = await http.get(
      Uri.parse(ApiConfig.userDetailUrl(userId)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to load user: ${response.statusCode} ${response.body}');
    }
  }
}
