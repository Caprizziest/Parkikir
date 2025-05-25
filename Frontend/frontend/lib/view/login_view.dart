import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/viewmodel/login_view_model.dart';

class LoginView extends ConsumerWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(loginViewModelProvider);

    InputDecoration _inputDecoration({Widget? suffixIcon}) {
      return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4B4BEE), width: 2.0),
        ),
        suffixIcon: suffixIcon,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // Logo
              Center(
                child: Image.asset(
                  'logo.png',
                  height: 120,
                ),
              ),
              const SizedBox(height: 60),
              // Log In Title with underline
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Log In',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 1),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 45,
                      height: 3,
                      color: const Color(0xFF4B4BEE),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 13),
              // Username Field
              const Text(
                'Username',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextField(
                controller: viewModel.usernameController,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 20),
              // Password Field
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextField(
                controller: viewModel.passwordController,
                obscureText: viewModel.obscureText,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                decoration: _inputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      viewModel.obscureText
                          ? PhosphorIcons.eyeClosed(PhosphorIconsStyle.bold)
                          : PhosphorIcons.eye(PhosphorIconsStyle.bold),
                      size: 24,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    onPressed: viewModel.togglePasswordVisibility,
                  ),
                ),
              ),
              // Forgot Password and Error Message Row
              // Forgot Password and Error Message Row
              Row(
                children: [
                  if (viewModel.errorMessage != null)
                    Expanded(
                      child: Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF4B4BEE),
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: viewModel.isFormValid && !viewModel.isLoading
                      ? () async {
                          final success = await viewModel.login();
                          if (success && context.mounted) {
                            context.go('/');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login successful!',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                    )),
                                backgroundColor:
                                    Color.fromARGB(255, 204, 252, 10),
                              ),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B4BEE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    disabledBackgroundColor:
                        const Color(0xFF4B4BEE).withOpacity(0.4),
                    disabledForegroundColor: Colors.white,
                  ),
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              // Create Account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have account? ',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () {
                      // Use GoRouter to navigate to register page
                      context.go('/register');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF4B4BEE),
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Create Here!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
