import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/auth/presentation/pages/login_page.dart';
import 'package:agrix/features/auth/presentation/state/auth_state.dart';
import 'package:agrix/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();

  bool _hiddenPassword = true;

  /// Handle Signup
  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authViewModelProvider.notifier)
          .register(
            fullName: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            phoneNumber: _phoneNumberController.text.trim(),
            address: _addressController.text.trim(),
          );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    // Listen to AuthState for success or error
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.registered) {
        showSnackBar(
          context: context,
          message: 'Registration successful! Please login.',
          isSuccess: true,
        );
        Navigator.of(context).pop();
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        showSnackBar(
          context: context,
          message: next.errorMessage!,
          isSuccess: false,
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.08),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: h * 0.05),

                  /// LOGO
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: w * 0.3,
                      maxHeight: h * 0.15,
                    ),
                    child: Image.asset(
                      'assets/images/logo-2.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: h * 0.03),

                  /// TITLE
                  Text(
                    'Create your Account',
                    style: GoogleFonts.crimsonPro(
                      fontSize: w * 0.09,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: h * 0.01),

                  /// SUBTITLE
                  Text(
                    'Please enter your details',
                    style: GoogleFonts.crimsonPro(
                      color: const Color(0xFF777777),
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: h * 0.04),

                  /// FORM FIELDS
                  _buildTextFormField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    iconPath: 'assets/icons/user.png',
                    w: w,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter your full name"
                                : null,
                  ),
                  SizedBox(height: h * 0.015),

                  _buildTextFormField(
                    controller: _emailController,
                    label: 'Email',
                    iconPath: 'assets/icons/email.png',
                    w: w,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter your email"
                                : null,
                  ),
                  SizedBox(height: h * 0.015),

                  _buildTextFormField(
                    controller: _passwordController,
                    label: 'Password',
                    iconPath: 'assets/icons/password.png',
                    w: w,
                    obscureText: _hiddenPassword,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter your password"
                                : null,
                    suffix: IconButton(
                      icon: Icon(
                        _hiddenPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _hiddenPassword = !_hiddenPassword;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: h * 0.015),

                  _buildTextFormField(
                    controller: _phoneNumberController,
                    label: 'Phone Number',
                    iconPath: 'assets/icons/phone.png',
                    w: w,
                  ),
                  SizedBox(height: h * 0.015),

                  _buildTextFormField(
                    controller: _addressController,
                    label: 'Address',
                    iconPath: 'assets/icons/address.png',
                    w: w,
                  ),
                  SizedBox(height: h * 0.05),

                  /// SIGNUP BUTTON
                  SizedBox(
                    width: w * 0.6,
                    height: h * 0.065,
                    child: ElevatedButton(
                      onPressed: _handleSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B3D0B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Signup",
                        style: GoogleFonts.crimsonPro(
                          fontSize: w * 0.055,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.02),

                  /// LOGIN LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.crimsonPro(
                          fontSize: w * 0.04,
                          color: const Color(0xFF7B7979),
                        ),
                      ),
                      SizedBox(width: w * 0.02),
                      GestureDetector(
                        onTap:
                            () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            ),
                        child: Text(
                          "Login!",
                          style: GoogleFonts.crimsonPro(
                            fontSize: w * 0.04,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: h * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable TextFormField builder
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String iconPath,
    required double w,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE9E9E9).withOpacity(0.45),
        labelText: label,
        labelStyle: GoogleFonts.crimsonPro(
          fontSize: w * 0.045,
          color: const Color(0xFF777777),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.all(w * 0.03),
          child: Image.asset(iconPath, width: w * 0.06, height: w * 0.06),
        ),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: w * 0.05,
          vertical: w * 0.045,
        ),
      ),
    );
  }
}
