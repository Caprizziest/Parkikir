import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/login_model.dart';
// Login ViewModel
class LoginViewModel extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  bool isLoading = false;

  LoginViewModel() {
    // Add listeners for text changes to update form validity
    usernameController.addListener(_updateFormState);
    passwordController.addListener(_updateFormState);
  }

  bool get isFormValid =>
      usernameController.text.isNotEmpty && passwordController.text.isNotEmpty;

  void _updateFormState() {
    notifyListeners();
  }

  void togglePasswordVisibility() {
    obscureText = !obscureText;
    notifyListeners();
  }

  Future<bool> login() async {
    if (!isFormValid) return false;

    try {
      isLoading = true;
      notifyListeners();

      // Create login model
      final loginData = LoginModel(
        username: usernameController.text,
        password: passwordController.text,
      );

      // Here you would normally call your authentication service
      // For now, we'll just simulate a delay
      await Future.delayed(const Duration(seconds: 1));

      // For demo, always return success
      return true;
    } catch (e) {
      // Handle any errors
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    usernameController.removeListener(_updateFormState);
    passwordController.removeListener(_updateFormState);
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

// Riverpod provider for LoginViewModel
final loginViewModelProvider = ChangeNotifierProvider.autoDispose((ref) {
  return LoginViewModel();
});