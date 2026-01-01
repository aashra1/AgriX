import 'package:agrix/features/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen3 extends StatefulWidget {
  const SplashScreen3({super.key});

  @override
  State<SplashScreen3> createState() => _SplashScreen3State();
}

class _SplashScreen3State extends State<SplashScreen3> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFED),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// LOGO
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: w * 0.3, // responsive logo width
                  ),
                  child: Image.asset(
                    "assets/images/logo-2.png",
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: h * 0.04),

                /// TITLE
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.08),
                  child: Text(
                    "Grow Smarter, Harvest Better",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.crimsonPro(
                      fontSize: w * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),

                SizedBox(height: h * 0.02),

                /// SUBTITLE
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.08),
                  child: Text(
                    "Join thousands of farmers using Agrix to boost productivity.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.crimsonPro(
                      fontSize: w * 0.045,
                      color: Colors.black87,
                    ),
                  ),
                ),

                SizedBox(height: h * 0.06),

                /// BUTTON
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
                      "Continue",
                      style: GoogleFonts.crimsonPro(
                        fontSize: w * 0.05,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
