import 'package:agrix/app/routes/routes.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/auth/presentation/pages/signup_page.dart';
import 'package:agrix/features/auth/presentation/state/auth_state.dart';
import 'package:agrix/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:agrix/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hiddenPassword = true;

  /// Login handler
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        AppRoutes.pushReplacement(context, HomeScreen());
        showSnackBar(
          context: context,
          message: "Login Successful",
          isSuccess: true,
        );
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        showSnackBar(
          context: context,
          message: next.errorMessage ?? "Login Failed",
          isSuccess: false,
        );
      }
    });

    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.08),
            child: Form(
              key: _formKey, // <-- Form key
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
                    'Welcome Back',
                    style: GoogleFonts.crimsonPro(
                      fontSize: w * 0.1,
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

                  SizedBox(height: h * 0.05),

                  /// EMAIL
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFE9E9E9).withOpacity(0.45),
                      labelText: 'Email',
                      labelStyle: GoogleFonts.crimsonPro(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF777777),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(w * 0.03),
                        child: Image.asset(
                          'assets/icons/email.png',
                          width: w * 0.06,
                          height: w * 0.06,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: w * 0.05,
                        vertical: h * 0.02,
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.025),

                  /// PASSWORD
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _hiddenPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFE9E9E9).withOpacity(0.45),
                      labelText: 'Password',
                      labelStyle: GoogleFonts.crimsonPro(
                        fontSize: w * 0.055,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF777777),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(w * 0.03),
                        child: Image.asset(
                          'assets/icons/password.png',
                          width: w * 0.06,
                          height: w * 0.06,
                        ),
                      ),
                      suffixIcon: IconButton(
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: w * 0.05,
                        vertical: h * 0.02,
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.01),

                  /// FORGOT PASSWORD
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot password?',
                      style: GoogleFonts.crimsonPro(
                        fontSize: w * 0.045,
                        color: Colors.red,
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.05),

                  /// LOGIN BUTTON
                  SizedBox(
                    width: w * 0.6,
                    height: h * 0.065,
                    child: ElevatedButton(
                      onPressed: _handleLogin, // <-- form validation used
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B3D0B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: GoogleFonts.crimsonPro(
                          fontSize: w * 0.055,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.02),

                  /// SIGNUP LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.crimsonPro(
                          fontSize: w * 0.04,
                          color: const Color(0xFF7B7979),
                        ),
                      ),
                      SizedBox(width: w * 0.02),
                      GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            ),
                        child: Text(
                          "Signup!",
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
}
