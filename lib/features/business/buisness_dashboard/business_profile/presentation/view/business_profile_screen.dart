import 'dart:io';

import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/business/buisness_dashboard/business_profile/domain/entity/business_profile_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/business_profile/presentation/state/business_profile_state.dart';
import 'package:agrix/features/business/buisness_dashboard/business_profile/presentation/viewmodel/business_profile_viewmodel.dart';
import 'package:agrix/features/business/buisness_dashboard/widgets/business_side_drawer.dart';
import 'package:agrix/screens/choices/login_choice.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BusinessProfileScreen extends ConsumerStatefulWidget {
  final bool isEditing;
  final VoidCallback onEditingComplete;

  const BusinessProfileScreen({
    super.key,
    required this.isEditing,
    required this.onEditingComplete,
  });

  @override
  ConsumerState<BusinessProfileScreen> createState() =>
      _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends ConsumerState<BusinessProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final int _selectedIndex = 3;
  bool _isLoggingOut = false;
  bool _imageError = false;

  late TextEditingController _businessNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  File? _selectedImage;
  String? _previewUrl;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadProfile();
  }

  void _initializeControllers() {
    _businessNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BusinessProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEditing != widget.isEditing) {
      setState(() {});
    }
  }

  Future<void> _loadProfile() async {
    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }
    await ref
        .read(businessProfileViewModelProvider.notifier)
        .getBusinessProfile(token: token);
  }

  void _showAuthError() {
    showSnackBar(
      context: context,
      message: 'Authentication required',
      isSuccess: false,
    );
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/business/login');
    });
  }

  void _handleNavigation(int index) {
    Navigator.pop(context);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/business/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/business/orders');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/business/payments');
        break;
      case 3:
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/business/customers');
        break;
      case -1:
        _handleLogout();
        break;
    }
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);
    await ref.read(userSessionServiceProvider).clearSession();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginSelectionScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedImage = File(result.files.first.path!);
        _previewUrl = null;
        _imageError = false;
      });
    }
  }

  String _getProfileImageUrl(String? imagePath) {
    if (_selectedImage != null) return '';
    if (imagePath == null || imagePath.isEmpty) return '';
    final fileName = imagePath.split('/').last;
    return '${ApiEndpoints.baseIp}/uploads/business-profiles/$fileName';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '2025';
    return DateFormat('MMMM d, yyyy').format(date);
  }

  Map<String, dynamic> _getStatusBadge(BusinessProfileEntity profile) {
    final status = profile.businessStatus;
    final verified = profile.businessVerified;

    if (status == BusinessStatus.approved && verified) {
      return {
        'color': const Color(0xFF2D6A4F),
        'bgColor': const Color(0xFF2D6A4F).withOpacity(0.1),
        'icon': Icons.check_circle,
        'text': 'Verified Business',
      };
    } else if (status == BusinessStatus.pending) {
      return {
        'color': Colors.orange,
        'bgColor': Colors.orange.withOpacity(0.1),
        'icon': Icons.error_outline,
        'text': 'Pending Verification',
      };
    } else if (status == BusinessStatus.rejected) {
      return {
        'color': Colors.red,
        'bgColor': Colors.red.withOpacity(0.1),
        'icon': Icons.cancel,
        'text': 'Verification Rejected',
      };
    }
    return {
      'color': Colors.grey,
      'bgColor': Colors.grey.withOpacity(0.1),
      'icon': Icons.shield_outlined,
      'text': 'Business Account',
    };
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }

    final state = ref.read(businessProfileViewModelProvider);
    final currentProfile = state.profile;

    await ref
        .read(businessProfileViewModelProvider.notifier)
        .updateBusinessProfile(
          token: token,
          businessName:
              _businessNameController.text.trim() !=
                      currentProfile?.businessName
                  ? _businessNameController.text.trim()
                  : null,
          email:
              _emailController.text.trim() != currentProfile?.email
                  ? _emailController.text.trim()
                  : null,
          phoneNumber:
              _phoneController.text.trim() != currentProfile?.phoneNumber
                  ? _phoneController.text.trim()
                  : null,
          address:
              _addressController.text.trim() != currentProfile?.address
                  ? _addressController.text.trim()
                  : null,
          imagePath: _selectedImage?.path,
        );
  }

  void _cancelEditing() {
    setState(() {
      _selectedImage = null;
      _imageError = false;
    });
    widget.onEditingComplete();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(businessProfileViewModelProvider);
    final profile = state.profile;
    final isEditing = widget.isEditing;

    ref.listen<BusinessProfileState>(businessProfileViewModelProvider, (
      previous,
      next,
    ) {
      if (next.status == BusinessProfileStatus.error &&
          next.errorMessage != null) {
        showSnackBar(
          context: context,
          message: next.errorMessage!,
          isSuccess: false,
        );
        widget.onEditingComplete();
      } else if (next.status == BusinessProfileStatus.updated) {
        showSnackBar(
          context: context,
          message: 'Profile updated successfully!',
          isSuccess: true,
        );
        widget.onEditingComplete();
        ref.read(businessProfileViewModelProvider.notifier).resetStatus();
      }
    });

    if (state.status == BusinessProfileStatus.loading && profile == null) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: BusinessSidebar(
          selectedIndex: _selectedIndex,
          onItemTapped: _handleNavigation,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
        ),
      );
    }

    if (profile == null) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: BusinessSidebar(
          selectedIndex: _selectedIndex,
          onItemTapped: _handleNavigation,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red.shade300,
                  ),
                ),
                const SizedBox(height: 24),
                Text('Failed to load profile', style: AppStyles.bodyLarge),
                const SizedBox(height: 8),
                Text(
                  'Please check your connection and try again',
                  style: AppStyles.caption.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loadProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Update controllers with profile data
    _businessNameController.text = profile.businessName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber;
    _addressController.text = profile.address ?? '';

    final imageUrl = _getProfileImageUrl(profile.profilePicture);
    final statusBadge = _getStatusBadge(profile);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF9FBF9),
      drawer: BusinessSidebar(
        selectedIndex: _selectedIndex,
        onItemTapped: _handleNavigation,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              image:
                                  _selectedImage != null
                                      ? DecorationImage(
                                        image: FileImage(_selectedImage!),
                                        fit: BoxFit.cover,
                                      )
                                      : (imageUrl.isNotEmpty && !_imageError
                                          ? DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                            onError:
                                                (_, __) => setState(
                                                  () => _imageError = true,
                                                ),
                                          )
                                          : null),
                              color:
                                  imageUrl.isEmpty || _imageError
                                      ? AppColors.primaryGreen
                                      : null,
                            ),
                            child:
                                (imageUrl.isEmpty || _imageError) &&
                                        _selectedImage == null
                                    ? const Center(
                                      child: Icon(
                                        Icons.business,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    )
                                    : null,
                          ),
                          if (isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.businessName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusBadge['bgColor'],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    statusBadge['icon'],
                                    size: 12,
                                    color: statusBadge['color'],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    statusBadge['text'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: statusBadge['color'],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildInfoChip(Icons.email_outlined, profile.email),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          Icons.phone_outlined,
                          profile.phoneNumber,
                        ),
                        const SizedBox(width: 8),
                        if (profile.address != null &&
                            profile.address!.isNotEmpty)
                          _buildInfoChip(
                            Icons.location_on_outlined,
                            profile.address!,
                          ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          Icons.calendar_today_outlined,
                          'Member since ${_formatDate(profile.createdAt)}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColors.primaryGreen, Color(0xFF059669)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Business Settings',
                        style: AppStyles.headline1.copyWith(
                          fontSize: 20,
                          color: Colors.grey[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.business,
                                size: 20,
                                color: AppColors.primaryGreen,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Business Information',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildFormField(
                            label: 'Business Name',
                            controller: _businessNameController,
                            icon: Icons.business,
                            isEditing: isEditing,
                            required: true,
                          ),
                          const SizedBox(height: 16),
                          _buildFormField(
                            label: 'Email Address',
                            controller: _emailController,
                            icon: Icons.email_outlined,
                            isEditing: isEditing,
                            keyboardType: TextInputType.emailAddress,
                            required: true,
                          ),
                          const SizedBox(height: 16),
                          _buildFormField(
                            label: 'Phone Number',
                            controller: _phoneController,
                            icon: Icons.phone_outlined,
                            isEditing: isEditing,
                            keyboardType: TextInputType.phone,
                            required: true,
                          ),
                          const SizedBox(height: 16),
                          _buildFormField(
                            label: 'Address',
                            controller: _addressController,
                            icon: Icons.location_on_outlined,
                            isEditing: isEditing,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (profile.businessDocument != null &&
                      profile.businessDocument!.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.shield_outlined,
                                  size: 20,
                                  color: AppColors.primaryGreen,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Verification Document',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[900],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Business Registration Document',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                                      Text(
                                        'Uploaded on ${_formatDate(profile.updatedAt)}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                    ),
                                    child: const Text(
                                      'View',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildActionTile(
                          icon: Icons.add_business,
                          label: 'Add New Product',
                          description: 'List a new product in your store',
                          onTap:
                              () => Navigator.pushNamed(
                                context,
                                '/business/products/add',
                              ),
                        ),
                        _buildActionTile(
                          icon: Icons.inventory_2_outlined,
                          label: 'Manage Products',
                          description: 'View and edit your products',
                          onTap:
                              () => Navigator.pushNamed(
                                context,
                                '/business/products',
                              ),
                        ),
                        _buildActionTile(
                          icon: Icons.shopping_bag_outlined,
                          label: 'View Orders',
                          description: 'Track and manage customer orders',
                          onTap:
                              () => Navigator.pushNamed(
                                context,
                                '/business/orders',
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      onTap: _isLoggingOut ? null : _handleLogout,
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            _isLoggingOut
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                  size: 20,
                                ),
                      ),
                      title: Text(
                        _isLoggingOut ? 'Logging out...' : 'Logout',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (isEditing)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  state.isUpdating ? null : _cancelEditing,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: state.isUpdating ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child:
                                  state.isUpdating
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : const Text(
                                        'Save Changes',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
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
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primaryGreen),
          const SizedBox(width: 4),
          Text(
            label.length > 25 ? '${label.substring(0, 22)}...' : label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isEditing,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isEditing ? Colors.white : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isEditing
                      ? AppColors.primaryGreen.withOpacity(0.3)
                      : Colors.grey.shade200,
            ),
          ),
          child: TextFormField(
            controller: controller,
            enabled: isEditing,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator:
                required
                    ? (val) =>
                        val == null || val.isEmpty ? '$label is required' : null
                    : null,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                size: 18,
                color:
                    isEditing ? AppColors.primaryGreen : Colors.grey.shade400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: TextStyle(
              fontSize: 14,
              color: isEditing ? const Color(0xFF1F2937) : Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: Colors.grey.shade700),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
