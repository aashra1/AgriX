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
    final size = MediaQuery.of(context).size;
    final w = size.width;

    int crossAxisCount = 2;
    if (w >= 900) {
      crossAxisCount = 4;
    } else if (w >= 600) {
      crossAxisCount = 3; 
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 2.8,
          crossAxisSpacing: w * 0.04,
          mainAxisSpacing: w * 0.04,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];

          return Container(
            padding: EdgeInsets.all(w * 0.03),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Image.asset(
                  category['icon'],
                  width: w * 0.07,
                  height: w * 0.07,
                  color: const Color(0xFFEBB61B),
                ),

                SizedBox(width: w * 0.03),

                Expanded(
                  child: Text(
                    category['name'],
                    style: GoogleFonts.crimsonPro(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(width: w * 0.02),
                
                Image.asset(
                  'assets/icons/to-right.png',
                  width: w * 0.035,
                  height: w * 0.035,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
