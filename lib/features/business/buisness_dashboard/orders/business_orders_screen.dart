import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessOrdersScreen extends StatelessWidget {
  const BusinessOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders',
          style: GoogleFonts.crimsonPro(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF0B3D0B),
      ),
      body: const Center(
        child: Text('Orders Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
