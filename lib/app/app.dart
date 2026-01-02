import 'package:agrix/app/theme/theme.dart';
import 'package:agrix/screens/onboarding/Splash_screen1.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      title: 'Agrix',
      home: const SplashScreen1(),
    );
  }
}