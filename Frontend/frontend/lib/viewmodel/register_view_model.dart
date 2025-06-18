import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/register_model.dart';
import '../repository/register_repository.dart';
import '../services/register_service.dart';

// Provider untuk service dan repository
final registerServiceProvider = Provider<RegisterService>((ref) {
  return RegisterService();
});

final registerRepositoryProvider = Provider<RegisterRepository>((ref) {
  final service = ref.watch(registerServiceProvider);
  return RegisterRepository(service: service);
});

// Register ViewModel
class RegisterViewModel extends ChangeNotifier {
  final RegisterRepository _repository;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscureText = true;
  bool isLoading = false;
  String? usernameError;
  String? emailError;
  String? passwordError;

  RegisterViewModel(this._repository) {
    usernameController.addListener(_updateFormState);
    emailController.addListener(_updateFormState);
    passwordController.addListener(_updateFormState);
  }

  // Simplified: button aktif selama semua form terisi
  bool get isFormValid =>
      usernameController.text.trim().isNotEmpty &&
      emailController.text.trim().isNotEmpty &&
      passwordController.text.isNotEmpty;

  void _updateFormState() {
    // Clear server errors ketika user mulai mengetik
    if (usernameError != null) usernameError = null;
    if (emailError != null) emailError = null;
    if (passwordError != null) passwordError = null;

    notifyListeners();
  }

  void togglePasswordVisibility() {
    obscureText = !obscureText;
    notifyListeners();
  }

  void clearErrors() {
    usernameError = null;
    emailError = null;
    passwordError = null;
    notifyListeners();
  }

  Future<RegisterResult> register() async {
    // Validasi client-side saat register
    Map<String, String> clientErrors = {};

    if (usernameController.text.trim().isEmpty) {
      clientErrors['username'] = 'Username is required';
    } else if (usernameController.text.trim().length < 3) {
      clientErrors['username'] = 'Username must be at least 3 characters';
    }

    if (emailController.text.trim().isEmpty) {
      clientErrors['email'] = 'Email is required';
    } else if (!_isValidEmail(emailController.text.trim())) {
      clientErrors['email'] = 'Please enter a valid email';
    }

    if (passwordController.text.isEmpty) {
      clientErrors['password'] = 'Password is required';
    } else if (passwordController.text.length < 6) {
      clientErrors['password'] = 'Password must be at least 6 characters';
    }

    // Set error untuk ditampilkan di UI jika ada validasi error
    if (clientErrors.isNotEmpty) {
      usernameError = clientErrors['username'];
      emailError = clientErrors['email'];
      passwordError = clientErrors['password'];
      notifyListeners();
      return RegisterResult.error('Please fill all fields correctly.');
    }

    try {
      isLoading = true;
      notifyListeners();

      final registerData = RegisterModel(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final result = await _repository.register(registerData);

      if (result['success'] == true) {
        clearErrors();
        _clearForm();
        return RegisterResult.success('Registration successful!');
      } else {
        _handleErrors(result['message']);
        return RegisterResult.error(_getErrorMessage(result['message']));
      }
    } catch (e) {
      return RegisterResult.error('Connection error: ${e.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _handleErrors(dynamic message) {
    usernameError = null;
    emailError = null;
    passwordError = null;

    if (message is Map) {
      if (message['username'] != null &&
          message['username'] is List &&
          message['username'].isNotEmpty) {
        usernameError = message['username'][0].toString();
      }
      if (message['email'] != null &&
          message['email'] is List &&
          message['email'].isNotEmpty) {
        emailError = message['email'][0].toString();
      }
      if (message['password'] != null &&
          message['password'] is List &&
          message['password'].isNotEmpty) {
        passwordError = message['password'][0].toString();
      }
    }
    notifyListeners();
  }

  String _getErrorMessage(dynamic message) {
    if (message is Map) {
      final allErrors = [
        if (usernameError != null) usernameError,
        if (emailError != null) emailError,
        if (passwordError != null) passwordError,
      ];
      return allErrors.isNotEmpty
          ? allErrors.join('\n')
          : 'Registration failed.';
    }
    return message?.toString() ?? 'Registration failed.';
  }

  void _clearForm() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
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

// Result class untuk better error handling
class RegisterResult {
  final bool isSuccess;
  final String message;

  RegisterResult._(this.isSuccess, this.message);

  factory RegisterResult.success(String message) =>
      RegisterResult._(true, message);
  factory RegisterResult.error(String message) =>
      RegisterResult._(false, message);
}

// Riverpod provider untuk RegisterViewModel
final registerViewModelProvider =
    ChangeNotifierProvider.autoDispose<RegisterViewModel>((ref) {
  final repository = ref.watch(registerRepositoryProvider);
  return RegisterViewModel(repository);
});
