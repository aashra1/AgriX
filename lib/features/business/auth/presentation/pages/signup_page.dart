import 'dart:io';

import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/business/auth/presentation/pages/login_page.dart';
import 'package:agrix/features/business/auth/presentation/pages/upload_document.dart';
import 'package:agrix/features/business/auth/presentation/state/business_auth_state.dart';
import 'package:agrix/features/business/auth/presentation/viewmodel/business_auth_viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessSignupScreen extends ConsumerStatefulWidget {
  const BusinessSignupScreen({super.key});

  @override
  ConsumerState<BusinessSignupScreen> createState() =>
      _BusinessSignupScreenState();
}

class _BusinessSignupScreenState extends ConsumerState<BusinessSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedProfilePicturePath;

  bool _hiddenPassword = true;

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedProfilePicturePath == null ||
        _selectedProfilePicturePath!.isEmpty) {
      showSnackBar(
        context: context,
        message: 'Please select a profile picture',
        isSuccess: false,
      );
      return;
    }

    ref
        .read(businessAuthViewModelProvider.notifier)
        .registerBusiness(
          businessName: _businessNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          address: _addressController.text.trim(),
          imagePath: _selectedProfilePicturePath,
        );
  }

  Future<void> _pickProfilePicture() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.single.path == null) return;

    setState(() {
      _selectedProfilePicturePath = result.files.single.path!;
    });
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    ref.listen<BusinessAuthState>(businessAuthViewModelProvider, (
      previous,
      next,
    ) {
      if (next.status == BusinessAuthStatus.registered) {
        showSnackBar(
          context: context,
          message: 'Business registered successfully! Please login.',
          isSuccess: true,
        );
        Navigator.of(context).pop();
      } else if (next.status == BusinessAuthStatus.needsDocumentUpload) {
        showSnackBar(
          context: context,
          message:
              'Business registered! Please upload your document for verification.',
          isSuccess: true,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BusinessDocumentUploadScreen(
                  tempToken: next.tempToken!,
                  businessEntity: next.businessEntity!,
                ),
          ),
        );
      } else if (next.status == BusinessAuthStatus.error &&
          next.errorMessage != null) {
        showSnackBar(
          context: context,
          message: next.errorMessage!,
          isSuccess: false,
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.08),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: h * 0.05),

                  /// LOGO
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: w * 0.3,
                      maxHeight: h * 0.15,
                    ),
                    child: Image.asset(
                      'assets/images/logo-2.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: h * 0.03),

                  /// TITLE
                  Text(
                    'Register Your Business',
                    style: GoogleFonts.crimsonPro(
                      fontSize: w * 0.09,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: h * 0.01),

                  /// SUBTITLE
                  Text(
                    'Please enter your business details',
                    style: GoogleFonts.crimsonPro(
                      color: const Color(0xFF777777),
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: h * 0.04),

                  /// PROFILE PICTURE PICKER
                  GestureDetector(
                    onTap: _pickProfilePicture,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: w * 0.13,
                          backgroundColor: const Color(0xFFE9E9E9),
                          backgroundImage:
                              _selectedProfilePicturePath != null
                                  ? FileImage(File(_selectedProfilePicturePath!))
                                  : null,
                          child:
                              _selectedProfilePicturePath == null
                                  ? Icon(
                                    Icons.person,
                                    size: w * 0.13,
                                    color: const Color(0xFF777777),
                                  )
                                  : null,
                        ),
                        CircleAvatar(
                          radius: w * 0.045,
                          backgroundColor: const Color(0xFF0B3D0B),
                          child: Icon(
                            Icons.add_a_photo,
                            size: w * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: h * 0.02),

                  /// FORM FIELDS
                  _buildTextFormField(
                    controller: _businessNameController,
                    label: 'Business Name',
                    iconPath: 'assets/icons/business.png',
                    w: w,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter your business name"
                                : null,
                  ),
                  SizedBox(height: h * 0.015),

                  _buildTextFormField(
                    controller: _emailController,
                    label: 'Business Email',
                    iconPath: 'assets/icons/email.png',
                    w: w,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter your business email"
                                : null,
                  ),
                  SizedBox(height: h * 0.015),

                  _buildTextFormField(
                    controller: _passwordController,
                    label: 'Password',
                    iconPath: 'assets/icons/password.png',
                    w: w,
                    obscureText: _hiddenPassword,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter your password"
                                : value.length < 6
                                ? "Password must be at least 6 characters"
                                : null,
                    suffix: IconButton(
                      icon: Icon(
                        _hiddenPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _hiddenPassword = !_hiddenPassword;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: h * 0.015),

                  _buildTextFormField(
                    controller: _phoneNumberController,
                    label: 'Business Phone Number',
                    iconPath: 'assets/icons/phone.png',
                    w: w,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter your business phone number"
                                : null,
                  ),
                  SizedBox(height: h * 0.015),

                  _buildTextFormField(
                    controller: _addressController,
                    label: 'Business Address',
                    iconPath: 'assets/icons/address.png',
                    w: w,
                  ),
                  SizedBox(height: h * 0.05),

                  /// SIGNUP BUTTON
                  SizedBox(
                    width: w * 0.6,
                    height: h * 0.065,
                    child: ElevatedButton(
                      onPressed: _handleSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B3D0B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Register Business",
                        style: GoogleFonts.crimsonPro(
                          fontSize: w * 0.055,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.02),

                  /// LOGIN LINK
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Already have a business account?",
                        style: GoogleFonts.crimsonPro(
                          fontSize: w * 0.04,
                          color: const Color(0xFF7B7979),
                        ),
                      ),
                      SizedBox(width: w * 0.02),
                      GestureDetector(
                        onTap:
                            () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BusinessLoginScreen(),
                              ),
                            ),
                        child: Text(
                          "Login!",
                          style: GoogleFonts.crimsonPro(
                            fontSize: w * 0.04,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: h * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable TextFormField builder
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String iconPath,
    required double w,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE9E9E9).withValues(alpha: 0.45),
        labelText: label,
        labelStyle: GoogleFonts.crimsonPro(
          fontSize: w * 0.045,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF777777),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.all(w * 0.03),
          child: Image.asset(iconPath, width: w * 0.06, height: w * 0.06),
        ),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: w * 0.05,
          vertical: w * 0.045,
        ),
      ),
    );
  }
}
