import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatefulWidget {
  final List<Widget> pages;

  const CustomBottomNavBar({super.key, required this.pages});

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
    // Responsive sizes
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double navHeight = screenHeight * 0.1;
    final double iconSize = screenWidth * 0.06;
    final double fontSizeSelected = screenWidth * 0.035;
    final double fontSizeUnselected = screenWidth * 0.03;
    final double paddingSelected = screenWidth * 0.04;

    final List<Map<String, String>> navItems = [
      {'icon': 'assets/icons/home.png', 'label': 'Home'},
      {'icon': 'assets/icons/favorite.png', 'label': 'Favorites'},
      {'icon': 'assets/icons/shopping-cart-2.png', 'label': 'Cart'},
      {'icon': 'assets/icons/user.png', 'label': 'Profile'},
    ];

    return Scaffold(
      body: widget.pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: navHeight,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: paddingSelected,
                    vertical: navHeight * 0.15,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B3D0B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        navItems[index]['icon']!,
                        width: iconSize,
                        height: iconSize,
                        color: Colors.white,
                      ),
                      SizedBox(width: paddingSelected * 0.5),
                      Text(
                        navItems[index]['label']!,
                        style: GoogleFonts.crimsonPro(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSizeSelected,
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
                    Image.asset(
                      navItems[index]['icon']!,
                      width: iconSize,
                      height: iconSize,
                    ),
                    SizedBox(height: navHeight * 0.05),
                    Text(
                      navItems[index]['label']!,
                      style: GoogleFonts.crimsonPro(
                        fontSize: fontSizeUnselected,
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
      ),
    );
  }
}
