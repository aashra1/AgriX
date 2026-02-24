import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/presentation/view/business_orders_screen.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/business_payments_screen.dart';
import 'package:agrix/features/business/buisness_dashboard/widgets/business_header_section.dart';
import 'package:agrix/features/business/buisness_dashboard/widgets/business_products_list.dart';
import 'package:agrix/features/business/buisness_dashboard/widgets/business_side_drawer.dart';
import 'package:agrix/features/users/profile/profile.dart';
import 'package:flutter/material.dart';

class BusinessHomeScreen extends StatefulWidget {
  const BusinessHomeScreen({super.key});

  @override
  State<BusinessHomeScreen> createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    "Dashboard",
    "Order Management",
    "Payments",
    "Profile",
  ];

  final List<Widget> _pages = [
    const BusinessHomeContent(),
    const BusinessOrdersPage(),
    const BusinessPaymentsScreen(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryGreen),
        title: Text(
          _titles[_selectedIndex],
          style: AppStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: BusinessSidebar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          if (index == -1) {
          } else {
            setState(() => _selectedIndex = index);
          }
          Navigator.pop(context);
        },
      ),
      body: _pages[_selectedIndex],
    );
  }
}

class BusinessHomeContent extends StatelessWidget {
  const BusinessHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BusinessHeaderSection(),
          const BusinessProductsList(),
          SizedBox(height: h * 0.05),
        ],
      ),
    );
  }
}
