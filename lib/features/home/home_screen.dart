import 'package:agrix/widgets/custom_navbar.dart';
import 'package:agrix/widgets/header_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderSection(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Categories",
                style: GoogleFonts.crimsonPro(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[900],
                ),
              ),
            ),
            const CategoriesGrid(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Exciting Offers",
                    style: GoogleFonts.crimsonPro(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[900],
                    ),
                  ),
                  Text(
                    "view all",
                    style: GoogleFonts.crimsonPro(
                      fontSize: 16,
                      color: Colors.green[800],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const OffersList(),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}



class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  final List<Map<String, dynamic>> categories = const [
    {"icon": "assets/icons/seeds.png", "name": "Seeds & Plants"},
    {"icon": "assets/icons/fertilizer.png", "name": "Fertilizers & Soil Care"},
    {"icon": "assets/icons/water-system.png", "name": "Irrigation"},
    {"icon": "assets/icons/pesticide.png", "name": "Pesticides"},
    {"icon": "assets/icons/sheep.png", "name": "Animal & Livestock"},
    {"icon": "assets/icons/tractor.png", "name": "Machinery & Equipments"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Image.asset(
                  category['icon'],
                  width: 30,
                  height: 30,
                  color: Color(0xFFEBB61B),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    category['name'],
                    style: GoogleFonts.crimsonPro(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: Image.asset(
                    'assets/icons/to-right.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class OffersList extends StatelessWidget {
  const OffersList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        children: [
          _buildOfferCard(
            'https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
          ),
          _buildOfferCard(
            'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
          ),
          _buildOfferCard(
            'https://images.unsplash.com/photo-1592982537447-6f2a6a0c7c18?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(String imageUrl) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
