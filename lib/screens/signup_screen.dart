import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'signin_screen.dart';
import '../widgets/signup_success_sheet.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  'lib/assets/images/Tafsila.png',
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              // Sign up text
              const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'enter your info',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              // Username field
              _buildTextField(
                hint: 'username',
                backgroundColor: const Color(0xFFF8F8FF),
              ),
              const SizedBox(height: 16),
              // Email field
              _buildTextField(
                hint: 'email',
                backgroundColor: const Color(0xFFF8F8FF),
              ),
              const SizedBox(height: 16),
              // Password field
              _buildTextField(
                hint: 'password',
                backgroundColor: const Color(0xFFF8F8FF),
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onVisibilityChanged: (value) {
                  setState(() {
                    _isPasswordVisible = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Confirm password field
              _buildTextField(
                hint: 'confirm password',
                backgroundColor: const Color(0xFFF8F8FF),
                isPassword: true,
                isPasswordVisible: _isConfirmPasswordVisible,
                onVisibilityChanged: (value) {
                  setState(() {
                    _isConfirmPasswordVisible = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Height field with Cm
              _buildTextFieldWithUnit(hint: 'enter your height', unit: 'Cm'),
              const SizedBox(height: 16),
              // Weight field with Kg
              _buildTextFieldWithUnit(hint: 'enter your weight', unit: 'Kg'),
              const SizedBox(height: 32),
              // Sign up button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Show success bottom sheet
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isDismissible: false,
                      enableDrag: false,
                      builder:
                          (context) => SignUpSuccessSheet(
                            onContinue: () {
                              Navigator.pop(context); // Close bottom sheet
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              );
                            },
                          ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B68EE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Sign in link
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'Sign in',
                        style: const TextStyle(
                          color: Color(0xFF7B68EE),
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInScreen(),
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required Color backgroundColor,
    bool isPassword = false,
    bool? isPasswordVisible,
    Function(bool)? onVisibilityChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: isPassword && !(isPasswordVisible ?? false),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      isPasswordVisible ?? false
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      onVisibilityChanged?.call(!(isPasswordVisible ?? false));
                    },
                  )
                  : null,
        ),
      ),
    );
  }

  Widget _buildTextFieldWithUnit({required String hint, required String unit}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                unit,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
