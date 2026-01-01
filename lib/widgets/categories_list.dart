import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    // Screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizing
    final double gridPadding = screenWidth * 0.05; // 5% of screen width
    final double iconSize = screenWidth * 0.08; // 8% of screen width
    final double spacing = screenWidth * 0.03; // 3% of screen width
    final double fontSize = screenWidth * 0.035; // scalable font

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gridPadding),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              screenWidth < 600 ? 2 : 3, // 2 columns on small, 3 on bigger
          childAspectRatio:
              screenWidth / screenHeight * 2.2, // responsive aspect
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(spacing),
            child: Row(
              children: [
                Image.asset(
                  category['icon'],
                  width: iconSize,
                  height: iconSize,
                  color: const Color(0xFFEBB61B),
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Text(
                    category['name'],
                    style: GoogleFonts.crimsonPro(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: iconSize * 0.5,
                  height: iconSize * 0.5,
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


