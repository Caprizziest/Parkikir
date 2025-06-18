import 'package:frontend/services/token_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final TokenService _tokenService = TokenService();

  /// Cek apakah user sudah login dengan token yang valid
  Future<bool> isLoggedIn() async {
    try {
      final token = await _tokenService.getAccessToken();

      if (token == null) {
        return false;
      }

      // Cek apakah token sudah expired
      if (JwtDecoder.isExpired(token)) {
        // Token expired, hapus token dan return false
        await _tokenService.deleteTokens();
        return false;
      }

      return true;
    } catch (e) {
      // Jika ada error, anggap tidak login
      return false;
    }
  }

  /// Logout user dan hapus semua token
  Future<void> logout() async {
    await _tokenService.deleteTokens();
  }

  /// Get current user ID from token
  Future<int?> getCurrentUserId() async {
    return await _tokenService.getUserId();
  }
}
