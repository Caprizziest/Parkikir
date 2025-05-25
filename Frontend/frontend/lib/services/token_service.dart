import 'package:shared_preferences/shared_preferences.dart';

class TokenService {

  // function untuk ambil access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // funtion untuk save access token dipakai saat login berhasil 
  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  // funtion untuk save refresh token dipakai saat login berhasil 
  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', token);
  }

  // function untuk hapus token saat dipakai saat logout
  static Future<void> deleteTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }
}