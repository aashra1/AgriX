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