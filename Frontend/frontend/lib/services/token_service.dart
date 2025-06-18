import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenService {
  // function untuk ambil access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // funtion untuk save access token dipakai saat login berhasil
  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  // funtion untuk save refresh token dipakai saat login berhasil
  Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', token);
  }

  // function untuk hapus token saat dipakai saat logout
  Future<void> deleteTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

    // ✅ New Method: Get User ID from Access Token
  Future<int?> getUserId() async {
    final token = await getAccessToken();
    if (token == null || JwtDecoder.isExpired(token)) {
      return null; // Token not found or expired
    }

    final decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['user_id'];

    if (userId is int) {
      return userId;
    } else if (userId is String) {
      return int.tryParse(userId); // Try parsing string to int
    }

    return null; // Invalid or missing user_id
  }
}
