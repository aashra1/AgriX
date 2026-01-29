import 'package:agrix/features/business/auth/presentation/pages/signup_page.dart';
import 'package:agrix/features/users/auth/presentation/pages/signup_page.dart';
import 'package:agrix/screens/choices/login_choice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupSelectionScreen extends StatefulWidget {
  const SignupSelectionScreen({super.key});

  @override
  State<SignupSelectionScreen> createState() => _SignupSelectionScreenState();
}

class _SignupSelectionScreenState extends State<SignupSelectionScreen> {
  UserRole _role = UserRole.initial;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    // If Customer is selected, show Customer Signup
    if (_role == UserRole.customer) {
      return const SignupScreen();
    }

    // If Seller is selected, show Business Signup
    if (_role == UserRole.seller) {
      return const BusinessSignupScreen();
    }

    // Initial selection screen
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
                  'Create Your Account',
                  style: GoogleFonts.crimsonPro(
                    fontSize: w * 0.1,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: h * 0.01),

                /// SUBTITLE
                Text(
                  'How would you like to sign up?',
                  style: GoogleFonts.crimsonPro(
                    color: const Color(0xFF777777),
                    fontSize: w * 0.05,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: h * 0.05),

                /// CUSTOMER BUTTON
                SizedBox(
                  width: w * 0.8,
                  height: h * 0.08,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _role = UserRole.customer;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B3D0B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Sign up as Customer",
                      style: GoogleFonts.crimsonPro(
                        fontSize: w * 0.055,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: h * 0.025),

                /// SELLER BUTTON
                SizedBox(
                  width: w * 0.8,
                  height: h * 0.08,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _role = UserRole.seller;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF0B3D0B),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      "Sign up as Seller",
                      style: GoogleFonts.crimsonPro(
                        fontSize: w * 0.055,
                        color: const Color(0xFF0B3D0B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: h * 0.05),

                /// LOGIN LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: GoogleFonts.crimsonPro(
                        fontSize: w * 0.045,
                        color: const Color(0xFF7B7979),
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginSelectionScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Login!",
                        style: GoogleFonts.crimsonPro(
                          fontSize: w * 0.045,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: h * 0.04),

                /// BACK TO LOGIN SELECTION (if needed)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Back to ",
                      style: GoogleFonts.crimsonPro(
                        fontSize: w * 0.04,
                        color: const Color(0xFF7B7979),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login Selection",
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
