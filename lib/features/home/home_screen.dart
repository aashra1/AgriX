import 'package:agrix/widgets/categories_list.dart';
import 'package:agrix/widgets/custom_navbar.dart';
import 'package:agrix/widgets/header_section.dart';
import 'package:agrix/widgets/offer_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER (already its own widget)
            const HeaderSection(),

            SizedBox(height: h * 0.025),

            /// CATEGORIES TITLE
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: Text(
                "Categories",
                style: GoogleFonts.crimsonPro(
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[900],
                ),
              ),
            ),

            SizedBox(height: h * 0.015),

            /// CATEGORIES GRID
            const CategoriesGrid(),

            SizedBox(height: h * 0.03),

            /// OFFERS HEADER
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Exciting Offers",
                    style: GoogleFonts.crimsonPro(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[900],
                    ),
                  ),
                  Text(
                    "view all",
                    style: GoogleFonts.crimsonPro(
                      fontSize: w * 0.04,
                      color: Colors.green[800],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.02),

            /// OFFERS LIST
            const OffersList(),

            SizedBox(height: h * 0.04),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
