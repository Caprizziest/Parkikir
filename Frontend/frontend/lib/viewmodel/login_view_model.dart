import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/token_service.dart';
import '../model/login_model.dart';
import '../repository/login_repository.dart';
import '../services/login_service.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginRepository _repository;
  final TokenService _tokenService;

  // State variables
  bool obscureText = true;
  bool isLoading = false;
  String? errorMessage;
  bool _disposed = false;

  LoginViewModel({LoginRepository? repository, TokenService? tokenService})
      : _repository = repository ??
            LoginRepository(
              service: LoginService(baseUrl: 'http://127.0.0.1:8000/api'),
            ),
        _tokenService = tokenService ?? TokenService() {
    usernameController.addListener(_updateFormState);
    passwordController.addListener(_updateFormState);
  }

  bool get isFormValid =>
      usernameController.text.isNotEmpty && passwordController.text.isNotEmpty;

  void _updateFormState() => notifyListeners();

  void togglePasswordVisibility() {
    obscureText = !obscureText;
    notifyListeners();
  }

  Future<bool> login() async {
    if (!isFormValid) return false;

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final loginData = LoginModel(
        username: usernameController.text,
        password: passwordController.text,
      );

      final result = await _repository.login(loginData);

      // if success simpan token , else tampilkan error
      if (result['success'] == true) {
        await _tokenService.saveAccessToken(result['access_token']);
        await _tokenService.saveRefreshToken(result['refresh_token']);
        return true;
      } else {
        errorMessage = "Invalid username or password";
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'System error occurred';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

final loginViewModelProvider =
    ChangeNotifierProvider.autoDispose<LoginViewModel>((ref) {
  return LoginViewModel();
});
