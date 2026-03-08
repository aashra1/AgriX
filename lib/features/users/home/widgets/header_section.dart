import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/features/users/profile/domain/entity/profile_entity.dart';
import 'package:agrix/features/users/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderSection extends ConsumerStatefulWidget {
  const HeaderSection({super.key});

  @override
  ConsumerState<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends ConsumerState<HeaderSection> {
  String _location = "Bouddha, Kathmandu";
  String _profileImageUrl = "";
  String _userName = "";
  bool _isLoading = true;
  bool _imageError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  Future<void> _loadUserProfile() async {
    final token = await ref.read(userSessionServiceProvider).getToken();

    if (token == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final profileState = ref.read(userProfileViewModelProvider);

      if (profileState.profile != null) {
        _updateProfileData(profileState.profile!);
      } else {
        await ref
            .read(userProfileViewModelProvider.notifier)
            .getUserProfile(token: token);

        final updatedState = ref.read(userProfileViewModelProvider);
        if (updatedState.profile != null) {
          _updateProfileData(updatedState.profile!);
        } else {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _updateProfileData(UserProfileEntity profile) {
    setState(() {
      _location = profile.address ?? "Bouddha, Kathmandu";
      _userName = profile.fullName;
      if (profile.profilePicture != null &&
          profile.profilePicture!.isNotEmpty) {
        final fileName = profile.profilePicture!.split('/').last;
        _profileImageUrl =
            "${ApiEndpoints.baseIp}/uploads/profiles/$fileName";
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/header.png"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(w * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP ROW
              Row(
                children: [
                  Image.asset(
                    "assets/icons/address.png",
                    width: w * 0.06,
                    height: w * 0.06,
                    color: Colors.black87,
                  ),
                  SizedBox(width: w * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your location",
                        style: GoogleFonts.crimsonPro(
                          color: Colors.black,
                          fontSize: w * 0.04,
                        ),
                      ),
                      _isLoading
                          ? Container(
                            width: 120,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          )
                          : Text(
                            _location,
                            style: GoogleFonts.crimsonPro(
                              color: const Color(0xFF1B5E20),
                              fontWeight: FontWeight.w500,
                              fontSize: w * 0.045,
                            ),
                          ),
                    ],
                  ),
                  const Spacer(),
                  Image.asset(
                    "assets/icons/bell.png",
                    width: w * 0.06,
                    height: w * 0.06,
                    color: Colors.black87,
                  ),
                  SizedBox(width: w * 0.04),
                  _isLoading
                      ? Container(
                        width: w * 0.09,
                        height: w * 0.09,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                      )
                      : CircleAvatar(
                        radius: w * 0.045,
                        backgroundColor: AppColors.primaryGreen.withOpacity(
                          0.1,
                        ),
                        backgroundImage:
                            _profileImageUrl.isNotEmpty && !_imageError
                                ? NetworkImage(_profileImageUrl)
                                : const AssetImage("assets/images/profile.jpg")
                                    as ImageProvider,
                        onBackgroundImageError: (_, __) {
                          setState(() => _imageError = true);
                        },
                        child:
                            _profileImageUrl.isEmpty || _imageError
                                ? Text(
                                  _userName.isNotEmpty
                                      ? _userName[0].toUpperCase()
                                      : "U",
                                  style: TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.04,
                                  ),
                                )
                                : null,
                      ),
                ],
              ),

              SizedBox(height: h * 0.03),

              /// SEARCH BAR
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(w * 0.03),
                      child: Image.asset(
                        'assets/icons/loupe-3.png',
                        width: w * 0.06,
                        height: w * 0.06,
                      ),
                    ),
                    hintText: "Search for a product",
                    hintStyle: GoogleFonts.crimsonPro(
                      color: const Color(0xFF7B7979),
                      fontSize: w * 0.04,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: h * 0.02),
                  ),
                ),
              ),

              SizedBox(height: h * 0.02),

              /// TAGLINE
              Text(
                "SHOP . TAP . GROW",
                style: GoogleFonts.crimsonPro(
                  color: const Color(0xFF0B3D0B),
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: h * 0.03),

              /// BUTTON AREA
              SizedBox(
                height: h * 0.25,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: SizedBox(
                        width: w * 0.42,
                        height: h * 0.065,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFDE7C),
                            foregroundColor: const Color(0xff0B3D0B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Explore",
                            style: GoogleFonts.crimsonPro(
                              fontSize: w * 0.045,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
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
}
