import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/auth_service.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
}

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthState _state = AuthState.initial;
  int? _userId;

  AuthState get state => _state;
  int? get userId => _userId;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;

  /// Initialize auth state - cek apakah user sudah login
  Future<void> initialize() async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      final isLoggedIn = await _authService.isLoggedIn();

      if (isLoggedIn) {
        _userId = await _authService.getCurrentUserId();
        _state = AuthState.authenticated;
      } else {
        _state = AuthState.unauthenticated;
        _userId = null;
      }
    } catch (e) {
      _state = AuthState.unauthenticated;
      _userId = null;
    }

    notifyListeners();
  }

  /// Set authenticated state after successful login
  Future<void> setAuthenticated() async {
    _userId = await _authService.getCurrentUserId();
    _state = AuthState.authenticated;
    notifyListeners();
  }

  /// Logout user
  Future<void> logout() async {
    await _authService.logout();
    _state = AuthState.unauthenticated;
    _userId = null;
    notifyListeners();
  }
}

/// Provider untuk AuthViewModel
final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  return AuthViewModel();
});
