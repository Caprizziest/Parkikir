import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/register_model.dart';
// Register ViewModel
class RegisterViewModel extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  bool isLoading = false;

  RegisterViewModel() {
    // Add listeners for text changes to update form validity
    usernameController.addListener(_updateFormState);
    emailController.addListener(_updateFormState);
    passwordController.addListener(_updateFormState);
  }

  bool get isFormValid =>
      usernameController.text.isNotEmpty &&
      emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty;

  void _updateFormState() {
    notifyListeners();
  }

  void togglePasswordVisibility() {
    obscureText = !obscureText;
    notifyListeners();
  }

  Future<bool> register() async {
    if (!isFormValid) return false;

    try {
      isLoading = true;
      notifyListeners();

      // Create register model
      final registerData = RegisterModel(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      // Here you would normally call your registration service
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
    emailController.removeListener(_updateFormState);
    passwordController.removeListener(_updateFormState);
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

// Riverpod provider for RegisterViewModel
final registerViewModelProvider = ChangeNotifierProvider.autoDispose((ref) {
  return RegisterViewModel();
});