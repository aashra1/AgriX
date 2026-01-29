import 'package:agrix/features/business/buisness_dashboard/orders/business_orders_screen.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/business_payments_screen.dart';
import 'package:agrix/features/business/buisness_dashboard/product/presentation/pages/business_add_product.dart';
import 'package:agrix/features/business/buisness_dashboard/widgets/business_bottom_navbar.dart';
import 'package:agrix/features/business/buisness_dashboard/widgets/business_header_section.dart';
import 'package:agrix/features/business/buisness_dashboard/widgets/business_products_list.dart';
import 'package:agrix/features/users/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessHomeScreen extends StatelessWidget {
  const BusinessHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BusinessBottomNavBar(
      pages: [
        const BusinessHomeContent(),
        BusinessAddProductScreen(),
        const BusinessOrdersScreen(),
        BusinessPaymentsScreen(),
        const ProfilePage(),
      ],
    );
  }
}

class BusinessHomeContent extends StatelessWidget {
  const BusinessHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BusinessHeaderSection(),
          SizedBox(height: h * 0.025),

          // Stats Cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: "Total Products",
                    value: "24",
                    icon: Icons.inventory_outlined,
                    color: const Color(0xFF0B3D0B),
                  ),
                ),
                SizedBox(width: w * 0.03),
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: "Orders Today",
                    value: "8",
                    icon: Icons.shopping_cart_outlined,
                    color: const Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.025),

          // Your Products Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Products",
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
                    color: const Color(0xFF0B3D0B),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.015),

          // Products List
          const BusinessProductsList(),
          SizedBox(height: h * 0.03),

          SizedBox(height: h * 0.015),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(w * 0.03),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: w * 0.06),
              ),
              Text(
                value,
                style: GoogleFonts.crimsonPro(
                  fontSize: w * 0.08,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.01),
          Text(
            title,
            style: GoogleFonts.crimsonPro(
              fontSize: w * 0.04,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
