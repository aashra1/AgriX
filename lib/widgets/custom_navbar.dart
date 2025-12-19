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
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final List<Map<String, String>> navItems = [
      {'icon': 'assets/icons/home.png', 'label': 'Home'},
      {'icon': 'assets/icons/favorite.png', 'label': 'Favorites'},
      {'icon': 'assets/icons/shopping-cart-2.png', 'label': 'Cart'},
      {'icon': 'assets/icons/user.png', 'label': 'Profile'},
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        w * 0.04,
        0,
        w * 0.04,
        bottomPadding > 0 ? bottomPadding : h * 0.02,
      ),
      child: Container(
        height: h * 0.09,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (index) {
            final isSelected = _selectedIndex == index;

            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding:
                    isSelected
                        ? EdgeInsets.symmetric(
                          horizontal: w * 0.05,
                          vertical: h * 0.012,
                        )
                        : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFF0B3D0B) : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child:
                    isSelected
                        ? Row(
                          children: [
                            Image.asset(
                              navItems[index]['icon']!,
                              width: w * 0.06,
                              height: w * 0.06,
                              color: Colors.white,
                            ),
                            SizedBox(width: w * 0.02),
                            Text(
                              navItems[index]['label']!,
                              style: GoogleFonts.crimsonPro(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: w * 0.038,
                              ),
                            ),
                          ],
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              navItems[index]['icon']!,
                              width: w * 0.06,
                              height: w * 0.06,
                            ),
                            SizedBox(height: h * 0.006),
                            Text(
                              navItems[index]['label']!,
                              style: GoogleFonts.crimsonPro(
                                fontSize: w * 0.032,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
