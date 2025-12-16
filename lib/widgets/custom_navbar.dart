import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> navItems = [
      {'icon': 'assets/icons/home.png', 'label': 'Home'},
      {'icon': 'assets/icons/favorite.png', 'label': 'Favorites'},
      {'icon': 'assets/icons/shopping-cart-2.png', 'label': 'Cart'},
      {'icon': 'assets/icons/user.png', 'label': 'Profile'},
    ];

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          bool isSelected = _selectedIndex == index;

          if (isSelected) {
            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B3D0B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      navItems[index]['icon']!,
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      navItems[index]['label']!,
                      style: GoogleFonts.crimsonPro(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(navItems[index]['icon']!, width: 24, height: 24),
                  const SizedBox(height: 4),
                  Text(
                    navItems[index]['label']!,
                    style: GoogleFonts.crimsonPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
