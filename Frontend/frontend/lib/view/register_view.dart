import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:frontend/viewmodel/register_view_model.dart';

class RegisterView extends ConsumerWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(registerViewModelProvider);

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
              // Create Account title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Account',
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
              // Username
              const Text(
                'Username',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: viewModel.usernameController,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                decoration: _inputDecoration(),
              ),
              SizedBox(
                height: 20,
                child: viewModel.usernameError != null
                    ? Text(
                        viewModel.usernameError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      )
                    : null,
              ),
              // Email
              const Text(
                'Email',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: viewModel.emailController,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                decoration: _inputDecoration(),
              ),
              SizedBox(
                height: 20,
                child: viewModel.emailError != null
                    ? Text(
                        viewModel.emailError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      )
                    : null,
              ),
              // Password
              const Text(
                'Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
              const SizedBox(height: 16),
              const Spacer(),
              // Register button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: viewModel.isFormValid
                      ? () async {
                          try {
                            final errorMsg = await viewModel.register();
                            if (errorMsg == null && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Registration successful!',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                      )),
                                  backgroundColor:
                                      Color.fromARGB(255, 204, 252, 10),
                                ),
                              );
                              context.go('/login');
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
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
                          'Register',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              // Login prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Use GoRouter to navigate back to login page
                      context.go('/login');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF4B4BEE),
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Login Here!',
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
