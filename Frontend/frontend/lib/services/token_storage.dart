// lib/services/token_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessTokenKey, token);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessTokenKey);
  }

  Future<void> deleteAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(accessTokenKey);
  }

  // New methods for refresh token
  Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(refreshTokenKey, token);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(refreshTokenKey);
  }

  Future<void> deleteRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(refreshTokenKey);
  }

  // Convenience method to store both tokens
  Future<void> storeTokens(String accessToken, String refreshToken) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  // Clear all tokens
  Future<void> clearTokens() async {
    await deleteAccessToken();
    await deleteRefreshToken();
  }
}

final tokenStorage = TokenStorage();
