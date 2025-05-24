import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/register_model.dart';
import '../services/register_service.dart';

// Register ViewModel
class RegisterViewModel extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  bool isLoading = false;
  final RegisterService _service =
      RegisterService(baseUrl: 'http://127.0.0.1:8000/api');
  String? usernameError;
  String? emailError;
  String? passwordError;

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

  Future<String?> register() async {
    if (!isFormValid) return 'Please fill all fields.';

    try {
      isLoading = true;
      notifyListeners();

      final registerData = RegisterModel(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      final result = await _service.register(registerData);
      if (result['success'] == true) {
        // Clear error fields
        usernameError = null;
        emailError = null;
        passwordError = null;
        notifyListeners();
        return null; // success
      } else {
        // result['message'] bisa String atau Map, handle keduanya
        final msg = result['message'];
        // Reset error fields
        usernameError = null;
        emailError = null;
        passwordError = null;
        if (msg is Map) {
          // Cek dan ambil error per field
          if (msg['username'] != null &&
              msg['username'] is List &&
              msg['username'].isNotEmpty) {
            usernameError = msg['username'][0].toString();
          }
          if (msg['email'] != null &&
              msg['email'] is List &&
              msg['email'].isNotEmpty) {
            emailError = msg['email'][0].toString();
          }
          if (msg['password'] != null &&
              msg['password'] is List &&
              msg['password'].isNotEmpty) {
            passwordError = msg['password'][0].toString();
          }
          // Gabungkan semua pesan error untuk snackbar
          final allErrors = [
            if (usernameError != null) usernameError,
            if (emailError != null) emailError,
            if (passwordError != null) passwordError,
          ];
          notifyListeners();
          return allErrors.isNotEmpty
              ? allErrors.join('\n')
              : 'Registration failed.';
        }
        if (msg is String) {
          notifyListeners();
          return msg;
        }
        notifyListeners();
        return 'Registration failed.';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
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
