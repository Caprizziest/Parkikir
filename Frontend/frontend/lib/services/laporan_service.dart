import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/report_model.dart';
import '../config/api_config.dart';
import 'token_storage.dart';

class LaporanService {
  final TokenStorage _tokenStorage;
  LaporanService(this._tokenStorage);

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

    // If token is expired, try to refresh
    if (response.statusCode == 401) {
      print('Token expired, attempting refresh...');

      // Try to refresh token
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        try {
          // Refresh the token
          await _refreshTokenIfNeeded();

          // Retry with new token
          token = await _getValidToken();
          final retryResponse = await http.get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ).timeout(ApiConfig.connectionTimeout);

          return retryResponse;
        } catch (e) {
          print('Token refresh failed: $e');
          // Clear invalid tokens
          await _tokenStorage.clearTokens();
          throw Exception('Session expired. Please login again.');
        }
      } else {
        // No refresh token available
        await _tokenStorage.clearTokens();
        throw Exception('Session expired. Please login again.');
      }
    }

    return response;
  }

  Future<void> _refreshTokenIfNeeded() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/auth/refresh/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh': refreshToken}),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['access'];

        if (newAccessToken != null) {
          await _tokenStorage.storeTokens(newAccessToken, refreshToken);
          print('Token refreshed successfully');
        } else {
          throw Exception('Invalid refresh response');
        }
      } else {
        throw Exception('Refresh failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error refreshing token: $e');
      rethrow;
    }
  }

  Future<List<ReportModel>> getAllLaporan() async {
    try {
      final response =
          await _makeAuthenticatedRequest('${ApiConfig.baseUrl}/laporan/');

      if (response.statusCode == 200) {
        try {
          final responseBody = response.body;
          print('API Response Body: $responseBody'); // Debug logging

          final List<dynamic> jsonList = jsonDecode(responseBody);
          print('Parsed JSON List length: ${jsonList.length}'); // Debug logging

          return jsonList.map((json) {
            print('Processing JSON item: $json'); // Debug logging
            return ReportModel.fromJson(json as Map<String, dynamic>);
          }).toList();
        } catch (e, stackTrace) {
          print('Error parsing response: $e');
          print('Stack trace: $stackTrace');
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception(
            'Failed to load laporan: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error in getAllLaporan: $e');
      rethrow;
    }
  }

  Future<ReportModel> getLaporanById(int id) async {
    try {
      final response =
          await _makeAuthenticatedRequest('${ApiConfig.baseUrl}/laporan/$id/');

      if (response.statusCode == 200) {
        try {
          final responseBody = response.body;
          print('API Detail Response Body: $responseBody'); // Debug logging

          final jsonData = jsonDecode(responseBody) as Map<String, dynamic>;
          print('Processing detail JSON: $jsonData'); // Debug logging

          return ReportModel.fromJson(jsonData);
        } catch (e, stackTrace) {
          print('Error parsing detail response: $e');
          print('Stack trace: $stackTrace');
          throw Exception('Failed to parse detail response: $e');
        }
      } else {
        throw Exception(
            'Failed to load laporan detail: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error in getLaporanById: $e');
      rethrow;
    }
  }
}
