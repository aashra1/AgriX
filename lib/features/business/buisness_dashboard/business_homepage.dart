import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/features/business/buisness_dashboard/business_customers/presentation/view/business_customer_screen.dart';
import 'package:agrix/features/business/buisness_dashboard/business_profile/presentation/view/business_profile_screen.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/presentation/view/business_orders_screen.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/presentation/view/business_payments_screen.dart';
import 'package:agrix/features/business/buisness_dashboard/widgets/business_header_section.dart';
import 'package:agrix/features/business/buisness_dashboard/widgets/business_products_list.dart';
import 'package:agrix/features/business/buisness_dashboard/widgets/business_side_drawer.dart';
import 'package:flutter/material.dart';

class BusinessHomeScreen extends StatefulWidget {
  const BusinessHomeScreen({super.key});

  @override
  State<BusinessHomeScreen> createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  int _selectedIndex = 0;
  bool _isProfileEditing = false;

  final List<String> _titles = [
    "Business Dashboard",
    "Order Management",
    "Business Earnings",
    "Business Profile",
    "Business Customers",
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const BusinessHomeContent(),
      const BusinessOrdersPage(),
      const BusinessPaymentsScreen(),
      BusinessProfileScreen(
        isEditing: _isProfileEditing,
        onEditingComplete: () {
          setState(() {
            _isProfileEditing = false;
          });
        },
      ),
      const BusinessCustomersScreen(),
    ];
  }

  void _toggleProfileEdit() {
    setState(() {
      _isProfileEditing = !_isProfileEditing;
    });
  }

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
        actions: [
          if (_selectedIndex == 3)
            IconButton(
              icon: Icon(
                _isProfileEditing ? Icons.close : Icons.edit_outlined,
                color: AppColors.primaryGreen,
              ),
              onPressed: _toggleProfileEdit,
            ),
        ],
      ),
      drawer: BusinessSidebar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          if (index == -1) {
            _handleLogout();
          } else {
            setState(() {
              _selectedIndex = index;
              _isProfileEditing = false; // Reset edit mode when switching tabs
            });
          }
          Navigator.pop(context);
        },
      ),
      body: _pages[_selectedIndex],
    );
  }

  void _handleLogout() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Add your logout logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.logoutRed,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
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
