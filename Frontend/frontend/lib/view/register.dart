import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/view/login.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const register());
}

class register extends StatelessWidget {
  const register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParkirKi\'',
      theme: ThemeData(
        primaryColor: const Color(0xFF4B4BEE),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      home: const RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateButtonOpacity);
    _emailController.addListener(_updateButtonOpacity);
    _passwordController.addListener(_updateButtonOpacity);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateButtonOpacity() {
    setState(() {});
  }

  bool get _isFormValid {
    return _usernameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  InputDecoration _inputDecoration({Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
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
                      color: Color(0xFF4B4BEE),
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
                controller: _usernameController,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 8),
              // Email
              const Text(
                'Email',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: _emailController,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 8),
              // Password
              const Text(
                'Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                decoration: _inputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText
                          ? PhosphorIcons.eyeClosed(PhosphorIconsStyle.bold)
                          : PhosphorIcons.eye(PhosphorIconsStyle.bold),
                      size: 24,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const Spacer(),
              // Register button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isFormValid ? () {} : null,
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
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
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
