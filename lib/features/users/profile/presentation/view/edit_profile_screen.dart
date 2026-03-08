import 'dart:io';

import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/users/profile/domain/entity/profile_entity.dart';
import 'package:agrix/features/users/profile/presentation/state/profile_state.dart';
import 'package:agrix/features/users/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isSaving = false;
  bool _imageError = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  File? _selectedImage;
  String? _profileImageUrl;
  UserProfileEntity? _originalProfile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserProfile());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }
    await ref
        .read(userProfileViewModelProvider.notifier)
        .getUserProfile(token: token);
  }

  void _showAuthError() {
    setState(() => _isLoading = false);
    showSnackBar(
      context: context,
      message: 'Authentication required',
      isSuccess: false,
    );
    Future.delayed(
      const Duration(seconds: 1),
      () => Navigator.pushReplacementNamed(context, '/login'),
    );
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedImage = File(result.files.first.path!);
        _imageError = false;
      });
    }
  }

  String _getProfileImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    final fileName = imagePath.split('/').last;
    return '${ApiEndpoints.baseIp}/uploads/profiles/$fileName';
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }

    setState(() => _isSaving = true);
    await ref
        .read(userProfileViewModelProvider.notifier)
        .updateUserProfile(
          token: token,
          fullName:
              _nameController.text.trim() != _originalProfile?.fullName
                  ? _nameController.text.trim()
                  : null,
          email:
              _emailController.text.trim() != _originalProfile?.email
                  ? _emailController.text.trim()
                  : null,
          phoneNumber:
              _phoneController.text.trim() != _originalProfile?.phoneNumber
                  ? _phoneController.text.trim()
                  : null,
          address:
              _addressController.text.trim() != _originalProfile?.address
                  ? _addressController.text.trim()
                  : null,
          imagePath: _selectedImage?.path,
        );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileViewModelProvider);
    final profile = profileState.profile;

    ref.listen<UserProfileState>(userProfileViewModelProvider, (prev, next) {
      if (next.status == UserProfileStatus.error && next.errorMessage != null) {
        showSnackBar(
          context: context,
          message: next.errorMessage!,
          isSuccess: false,
        );
        setState(() => _isSaving = false);
      } else if (next.status == UserProfileStatus.updated) {
        showSnackBar(
          context: context,
          message: 'Profile updated successfully!',
          isSuccess: true,
        );
        setState(() => _isSaving = false);
        Navigator.pop(context);
      }
    });

    if (profileState.status == UserProfileStatus.loading && profile == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
        ),
      );
    }

    if (profile != null && _isLoading) {
      _originalProfile = profile;
      _nameController.text = profile.fullName;
      _emailController.text = profile.email;
      _phoneController.text = profile.phoneNumber;
      _addressController.text = profile.address ?? '';
      _profileImageUrl = _getProfileImageUrl(profile.profilePicture);
      _imageError = false;
      setState(() => _isLoading = false);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF2F2F2),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE8F5E9),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFFF1F8F1),
                      backgroundImage:
                          _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (_profileImageUrl != null &&
                                      _profileImageUrl!.isNotEmpty &&
                                      !_imageError
                                  ? NetworkImage(_profileImageUrl!)
                                  : null),
                      onBackgroundImageError:
                          (_, __) => setState(() => _imageError = true),
                      child:
                          (_selectedImage == null &&
                                  (_profileImageUrl == null ||
                                      _profileImageUrl!.isEmpty ||
                                      _imageError))
                              ? const Icon(
                                Icons.person,
                                size: 55,
                                color: Color(0xFF5D7A5D),
                              )
                              : null,
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Edit your details",
                style: AppStyles.formTitle.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 4),
              Text(
                "Enter your details to update your profile",
                style: AppStyles.caption.copyWith(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 35),
              _buildTextField(
                iconPath: 'assets/icons/user.png',
                controller: _nameController,
                hint: 'Full Name',
                validator:
                    (val) =>
                        val == null || val.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                iconPath: 'assets/icons/email.png',
                controller: _emailController,
                hint: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                validator:
                    (val) =>
                        (val == null || !val.contains('@'))
                            ? 'Enter a valid email'
                            : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                iconPath: 'assets/icons/phone.png',
                controller: _phoneController,
                hint: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                iconPath: 'assets/icons/address.png',
                controller: _addressController,
                hint: 'Address',
              ),
              const SizedBox(height: 45),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isSaving ? null : _saveProfile,
                  child:
                      _isSaving
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Text(
                            "Save",
                            style: AppStyles.buttonText.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String iconPath,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: AppStyles.inputField.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Image.asset(iconPath, width: 20, color: Colors.black87),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 40),
        hintText: hint,
        hintStyle: AppStyles.caption.copyWith(color: Colors.grey[500]),
        filled: true,
        fillColor: const Color(0xFFF2F2F2),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(height: 0.8),
      ),
    );
  }
}
