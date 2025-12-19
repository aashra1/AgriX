import 'package:agrix/features/auth/signup/signup.dart';
import 'package:agrix/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
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
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFE9E9E9).withOpacity(0.45),
                    labelText: 'Email',
                    labelStyle: GoogleFonts.crimsonPro(
                      fontSize: w * 0.05,
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
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFE9E9E9).withOpacity(0.45),
                    labelText: 'Password',
                    labelStyle: GoogleFonts.crimsonPro(
                      fontSize: w * 0.055,
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
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
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
    );
  }
}
