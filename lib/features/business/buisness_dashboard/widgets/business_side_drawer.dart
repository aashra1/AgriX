import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:flutter/material.dart';

class BusinessSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BusinessSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Drawer(
      width: w * 0.8,
      backgroundColor: AppColors.backgroundWhite,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          children: [
            _buildProfileHeader(w),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: w * 0.02),
                children: [
                  _navItem(0, 'assets/icons/home.png', "Home"),
                  _navItem(1, 'assets/icons/orders.png', "Orders"),
                  _navItem(2, 'assets/icons/wallet.png', "Payments"),
                  _navItem(3, 'assets/icons/user.png', "Profile"),
                  _navItem(4, 'assets/icons/customer.png', "Customers"),
                ],
              ),
            ),
            const Divider(indent: 20, endIndent: 20),
            _navItem(-1, 'assets/icons/logout.png', "Log Out"),
            SizedBox(height: w * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(double w) {
    return Padding(
      padding: EdgeInsets.all(w * 0.06),
      child: Row(
        children: [
          CircleAvatar(
            radius: w * 0.05,
            backgroundImage: const AssetImage("assets/images/profile.jpg"),
          ),
          SizedBox(width: w * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Şennur Oruç", style: AppStyles.bodyLarge),
              Text("Business Owner", style: AppStyles.caption),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, String iconPath, String label, {int? count}) {
    final bool isActive = selectedIndex == index;
    final bool isLogout = index == -1;

    final Color itemColor =
        isLogout
            ? AppColors.logoutRed
            : (isActive ? AppColors.sidebarAccent : AppColors.textGrey);

    final TextStyle itemTextStyle =
        isLogout
            ? AppStyles.sidebarLogout
            : (isActive ? AppStyles.sidebarItemActive : AppStyles.sidebarItem);

    return InkWell(
      onTap: () => onItemTapped(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color:
              isActive
                  ? AppColors.sidebarAccent.withOpacity(0.08)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 20,
              height: 20,
              color: itemColor,
              errorBuilder:
                  (context, error, stackTrace) => Icon(
                    Icons.warning_amber_rounded,
                    size: 20,
                    color: itemColor,
                  ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: itemTextStyle.copyWith(color: itemColor),
              ),
            ),
            if (count != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.sidebarAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "$count",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
