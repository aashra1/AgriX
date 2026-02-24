// import 'package:agrix/features/business/buisness_dashboard/widgets/business_side_drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class BusinessBottomNavBar extends StatefulWidget {
//   final List<Widget> pages;

//   const BusinessBottomNavBar({super.key, required this.pages});

//   @override
//   State<BusinessBottomNavBar> createState() => _BusinessBottomNavBarState();
// }

// class _BusinessBottomNavBarState extends State<BusinessBottomNavBar> {
//   int _selectedIndex = 0;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   void _openDrawer() {
//     _scaffoldKey.currentState?.openDrawer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     final double navHeight = screenHeight * 0.1;
//     final double iconSize = screenWidth * 0.06;
//     final double fontSizeSelected = screenWidth * 0.035;
//     final double fontSizeUnselected = screenWidth * 0.03;
//     final double paddingSelected = screenWidth * 0.04;

//     final List<Map<String, String>> navItems = [
//       {'icon': 'assets/icons/home.png', 'label': 'Dashboard'},
//       {'icon': 'assets/icons/orders.png', 'label': 'Orders'},
//       {'icon': 'assets/icons/payment.png', 'label': 'Payments'},
//       {'icon': 'assets/icons/user.png', 'label': 'Profile'},
//     ];

//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: const BusinessDrawer(), // Add the drawer here
//       body: Stack(
//         children: [
//           // Main content
//           widget.pages[_selectedIndex],

//           // Menu button for drawer (positioned at top left)
//           Positioned(
//             top: screenHeight * 0.05,
//             left: screenWidth * 0.04,
//             child: GestureDetector(
//               onTap: _openDrawer,
//               child: Container(
//                 padding: EdgeInsets.all(screenWidth * 0.02),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       blurRadius: 5,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   Icons.menu,
//                   size: screenWidth * 0.06,
//                   color: const Color(0xFF0B3D0B),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         height: navHeight,
//         margin: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: List.generate(navItems.length, (index) {
//             bool isSelected = _selectedIndex == index;

//             if (isSelected) {
//               return GestureDetector(
//                 onTap: () => _onItemTapped(index),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: paddingSelected,
//                     vertical: navHeight * 0.15,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF0B3D0B),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       Image.asset(
//                         navItems[index]['icon']!,
//                         width: iconSize,
//                         height: iconSize,
//                         color: Colors.white,
//                       ),
//                       SizedBox(width: paddingSelected * 0.5),
//                       Text(
//                         navItems[index]['label']!,
//                         style: GoogleFonts.crimsonPro(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: fontSizeSelected,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             } else {
//               return GestureDetector(
//                 onTap: () => _onItemTapped(index),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       navItems[index]['icon']!,
//                       width: iconSize,
//                       height: iconSize,
//                       color: Colors.grey[600],
//                     ),
//                     SizedBox(height: navHeight * 0.05),
//                     Text(
//                       navItems[index]['label']!,
//                       style: GoogleFonts.crimsonPro(
//                         fontSize: fontSizeUnselected,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//           }),
//         ),
//       ),
//     );
//   }
// }
