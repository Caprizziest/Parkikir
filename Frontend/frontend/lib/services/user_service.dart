import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';
import '../config/api_config.dart';
import 'token_storage.dart';

class UserService {
  final TokenStorage _tokenStorage;
  UserService(this._tokenStorage);

  Future<String?> _getValidToken() async {
    String? token = await _tokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('No access token found. Please login again.');
    }

    return token;
  }

  Future<http.Response> _makeAuthenticatedRequest(String url) async {
    String? token = await _getValidToken();

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(ApiConfig.connectionTimeout);

    // If token is expired, clear tokens and throw error
    if (response.statusCode == 401) {
      print('Token expired for user service');
      await _tokenStorage.clearTokens();
      throw Exception('Session expired. Please login again.');
    }

    return response;
  }

  Future<UserModel> fetchUserById(int userId) async {
    try {
      final response =
          await _makeAuthenticatedRequest(ApiConfig.userDetailUrl(userId));
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to load user: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error in fetchUserById: $e');
      rethrow;
    }
  }
}
