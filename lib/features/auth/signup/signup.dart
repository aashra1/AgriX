import 'package:agrix/features/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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

                /// INPUT FIELDS
                ..._buildTextFields(w, h),

                SizedBox(height: h * 0.05),

                /// SIGNUP BUTTON
                SizedBox(
                  width: w * 0.6,
                  height: h * 0.065,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
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
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
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
    );
  }

  List<Widget> _buildTextFields(double w, double h) {
    final fields = [
      {'label': 'Full Name', 'icon': 'assets/icons/user.png', 'obscure': false},
      {'label': 'Email', 'icon': 'assets/icons/email.png', 'obscure': false},
      {
        'label': 'Password',
        'icon': 'assets/icons/password.png',
        'obscure': true,
      },
      {
        'label': 'Phone Number',
        'icon': 'assets/icons/phone.png',
        'obscure': true,
      },
      {'label': 'Address', 'icon': 'assets/icons/address.png', 'obscure': true},
    ];

    return fields.map((field) {
      return Padding(
        padding: EdgeInsets.only(bottom: h * 0.015),
        child: TextField(
          obscureText: field['obscure'] as bool,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE9E9E9).withOpacity(0.45),
            labelText: field['label'] as String,
            labelStyle: GoogleFonts.crimsonPro(
              fontSize: w * 0.045,
              color: const Color(0xFF777777),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(w * 0.03),
              child: Image.asset(
                field['icon'] as String,
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
      );
    }).toList();
  }
}
