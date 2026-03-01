import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/users/auth/presentation/pages/login_page.dart';
import 'package:agrix/features/users/profile/presentation/state/profile_state.dart';
import 'package:agrix/features/users/profile/presentation/view/edit_profile_screen.dart';
import 'package:agrix/features/users/profile/presentation/view/widgets/change_password_dialog.dart';
import 'package:agrix/features/users/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with WidgetsBindingObserver {
  bool _isLoading = true;
  String _fullName = "User";
  String? _profileImageUrl;
  bool _imageError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadUserProfile();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      setState(() => _isLoading = false);
      _showAuthError();
      return;
    }
    await ref
        .read(userProfileViewModelProvider.notifier)
        .getUserProfile(token: token);
  }

  void _showAuthError() {
    showSnackBar(
      context: context,
      message: 'Authentication required',
      isSuccess: false,
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    });
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.logoutRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
    );

    if (shouldLogout == true) {
      await ref.read(userSessionServiceProvider).clearSession();
      ref.read(userProfileViewModelProvider.notifier).reset();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  String _getProfileImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    final fileName = imagePath.split('/').last;
    return '${ApiEndpoints.baseIp}/uploads/profiles/$fileName';
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileViewModelProvider);

    ref.listen<UserProfileState>(userProfileViewModelProvider, (
      previous,
      next,
    ) {
      if (next.status == UserProfileStatus.error && next.errorMessage != null) {
        showSnackBar(
          context: context,
          message: next.errorMessage!,
          isSuccess: false,
        );
        setState(() => _isLoading = false);
      } else if (next.status == UserProfileStatus.loaded &&
          next.profile != null) {
        setState(() {
          _fullName = next.profile!.fullName;
          _profileImageUrl = _getProfileImageUrl(next.profile!.profilePicture);
          _isLoading = false;
        });
      }
    });

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryGreen,
            strokeWidth: 3,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryGreen.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: AppColors.primaryGreen.withOpacity(
                          0.05,
                        ),
                        backgroundImage:
                            _profileImageUrl != null && !_imageError
                                ? NetworkImage(_profileImageUrl!)
                                : const AssetImage(
                                      'assets/icons/user_avatar.png',
                                    )
                                    as ImageProvider,
                        onBackgroundImageError:
                            (_, __) => setState(() => _imageError = true),
                        child:
                            _profileImageUrl == null || _imageError
                                ? Text(
                                  _fullName.isNotEmpty
                                      ? _fullName[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryGreen,
                                  ),
                                )
                                : null,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, ${_fullName.split(' ').first}",
                            style: AppStyles.bodyLarge.copyWith(
                              fontSize: 24,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            "Welcome back",
                            style: AppStyles.caption.copyWith(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatusItem(
                      'assets/icons/fast-delivery.png',
                      'To Ship',
                    ),
                    _buildStatusItem('assets/icons/file.png', 'Orders'),
                    _buildStatusItem('assets/icons/delivery.png', 'To Receive'),
                    _buildStatusItem('assets/icons/pay.png', 'To Pay'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildListTile(
                      'assets/icons/user.png',
                      'Edit Your Profile',
                      () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                        if (result == true || mounted) {
                          _loadUserProfile();
                        }
                      },
                    ),
                    _buildListTile(
                      'assets/icons/password.png',
                      'Change Password',
                      () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        );
                        if (result == true || mounted) {
                          _loadUserProfile();
                        }
                      },
                    ),
                    _buildListTile(
                      'assets/icons/logout.png',
                      'Logout',
                      _handleLogout,
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem(String iconPath, String label) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, height: 26, width: 26),
          const SizedBox(height: 10),
          Text(
            label,
            style: AppStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    String iconPath,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color:
            isDestructive ? Colors.red.withOpacity(0.02) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                isDestructive
                    ? AppColors.logoutRed.withOpacity(0.1)
                    : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            iconPath,
            width: 20,
            color: isDestructive ? AppColors.logoutRed : null,
          ),
        ),
        title: Text(
          title,
          style: AppStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isDestructive ? AppColors.logoutRed : AppColors.textBlack,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color:
              isDestructive
                  ? AppColors.logoutRed.withOpacity(0.5)
                  : Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }
}
