import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/features/business/buisness_dashboard/business_profile/presentation/viewmodel/business_profile_viewmodel.dart';
import 'package:agrix/screens/choices/login_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessSidebar extends ConsumerStatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BusinessSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  ConsumerState<BusinessSidebar> createState() => _BusinessSidebarState();
}

class _BusinessSidebarState extends ConsumerState<BusinessSidebar> {
  String _businessName = "Business";
  String _businessOwner = "Business Owner";
  bool _isLoading = true;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadBusinessProfile();
  }

  Future<void> _loadBusinessProfile() async {
    final token = await ref.read(userSessionServiceProvider).getToken();

    if (token == null) {
      setState(() {
        _businessName = "Guest";
        _businessOwner = "Not logged in";
        _isLoading = false;
      });
      return;
    }

    try {
      final profileState = ref.read(businessProfileViewModelProvider);

      if (profileState.profile != null) {
        setState(() {
          _businessName = profileState.profile!.businessName;
          _businessOwner = "Business Owner";
          _isLoading = false;
        });
      } else {
        await ref
            .read(businessProfileViewModelProvider.notifier)
            .getBusinessProfile(token: token);

        final updatedState = ref.read(businessProfileViewModelProvider);
        if (updatedState.profile != null) {
          setState(() {
            _businessName = updatedState.profile!.businessName;
            _businessOwner = "Business Owner";
            _isLoading = false;
          });
        } else {
          setState(() {
            _businessName = "Business";
            _businessOwner = "Business Owner";
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _businessName = "Business";
        _businessOwner = "Business Owner";
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.logoutRed,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
    );

    if (shouldLogout != true) return;

    setState(() => _isLoggingOut = true);

    try {
      await ref.read(userSessionServiceProvider).clearSession();
      ref.read(businessProfileViewModelProvider.notifier).reset();

      if (mounted) {
        Navigator.pop(context);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginSelectionScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() => _isLoggingOut = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
            _navItem(
              -1,
              'assets/icons/logout.png',
              _isLoggingOut ? "Logging out..." : "Log Out",
            ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isLoading
                    ? Container(
                      width: 100,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                    : Text(
                      _businessName,
                      style: AppStyles.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                const SizedBox(height: 4),
                _isLoading
                    ? Container(
                      width: 80,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                    : Text(
                      _businessOwner,
                      style: AppStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, String iconPath, String label, {int? count}) {
    final bool isActive = widget.selectedIndex == index;
    final bool isLogout = index == -1;
    final bool isLoggingOut = isLogout && _isLoggingOut;

    final Color itemColor =
        isLoggingOut
            ? AppColors.logoutRed.withOpacity(0.5)
            : isLogout
            ? AppColors.logoutRed
            : (isActive ? AppColors.sidebarAccent : AppColors.textGrey);

    final TextStyle itemTextStyle =
        isLogout
            ? AppStyles.sidebarLogout
            : (isActive ? AppStyles.sidebarItemActive : AppStyles.sidebarItem);

    return InkWell(
      onTap:
          isLoggingOut
              ? null
              : () {
                if (isLogout) {
                  _handleLogout();
                } else {
                  widget.onItemTapped(index);
                }
              },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color:
              isActive && !isLogout
                  ? AppColors.sidebarAccent.withOpacity(0.08)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (isLoggingOut)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppColors.logoutRed,
                  strokeWidth: 2,
                ),
              )
            else
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
