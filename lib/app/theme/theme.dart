import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF0B3D0B),
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.crimsonProTextTheme(
      TextTheme(
        bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFFDE7C),
        foregroundColor: Color(0xFF0B3D0B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
  );
}
