import 'package:agrix/screens/onboarding/Splash_screen3.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
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
                /// IMAGE
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: w * 0.8, // responsive image width
                  ),
                  child: Image.asset(
                    "assets/images/splash2.png",
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: h * 0.04),

                /// TEXT
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.1),
                  child: Text(
                    "Empowering Farmers with Smart Agriculture Solutions",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.crimsonPro(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
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
                          builder: (context) => const SplashScreen3(),
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
                        fontSize: w * 0.055,
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
