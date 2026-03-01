import 'package:agrix/screens/onboarding/Splash_screen2.dart';
import 'package:flutter/material.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return; 

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen2()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FFED),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: w * 0.6, // 👈 better for tablets
            ),
            child: Image.asset("assets/images/logo.png", fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
