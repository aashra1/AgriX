import 'dart:io';

import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/business/auth/domain/entities/business_auth_entity.dart';
import 'package:agrix/features/business/auth/presentation/state/business_auth_state.dart';
import 'package:agrix/features/business/auth/presentation/viewmodel/business_auth_viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessDocumentUploadScreen extends ConsumerStatefulWidget {
  final String tempToken;
  final BusinessAuthEntity businessEntity;

  const BusinessDocumentUploadScreen({
    super.key,
    required this.tempToken,
    required this.businessEntity,
  });

  @override
  ConsumerState<BusinessDocumentUploadScreen> createState() =>
      _BusinessDocumentUploadScreenState();
}

class _BusinessDocumentUploadScreenState
    extends ConsumerState<BusinessDocumentUploadScreen> {
  File? _selectedDocument;
  bool _isUploading = false;

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedDocument = File(result.files.first.path!);
      });
    }
  }

  Future<void> _uploadDocument() async {
    if (_selectedDocument == null) {
      showSnackBar(
        context: context,
        message: 'Please select a document first',
        isSuccess: false,
      );
      return;
    }

    setState(() => _isUploading = true);

    await ref
        .read(businessAuthViewModelProvider.notifier)
        .uploadBusinessDocument(
          businessId: widget.businessEntity.businessId ?? '',
          documentPath: _selectedDocument!.path,
        );

    setState(() => _isUploading = false);
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: GoogleFonts.crimsonPro(
              fontSize: 16,
              color: const Color(0xFF777777),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.crimsonPro(
                fontSize: 16,
                color: const Color(0xFF777777),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.crimsonPro(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0B3D0B),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.crimsonPro(
                fontSize: 16,
                color: const Color(0xFF777777),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    // Listen for document upload success
    ref.listen<BusinessAuthState>(businessAuthViewModelProvider, (
      previous,
      next,
    ) {
      if (next.status == BusinessAuthStatus.documentUploaded) {
        showSnackBar(
          context: context,
          message: 'Document uploaded successfully! Awaiting admin approval.',
          isSuccess: true,
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (next.status == BusinessAuthStatus.error) {
        showSnackBar(
          context: context,
          message: next.errorMessage ?? 'Document upload failed',
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
                  'Upload Business Document',
                  style: GoogleFonts.crimsonPro(
                    fontSize: w * 0.09,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: h * 0.01),

                /// SUBTITLE
                Text(
                  'Please upload your business verification document',
                  style: GoogleFonts.crimsonPro(
                    color: const Color(0xFF777777),
                    fontSize: w * 0.045,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: h * 0.04),

                /// BUSINESS INFO CARD
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(w * 0.05),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9E9E9).withOpacity(0.45),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Business Information',
                        style: GoogleFonts.crimsonPro(
                          fontSize: w * 0.055,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0B3D0B),
                        ),
                      ),
                      SizedBox(height: h * 0.02),
                      _buildInfoRow(
                        'Business Name:',
                        widget.businessEntity.businessName,
                      ),
                      SizedBox(height: h * 0.01),
                      _buildInfoRow('Email:', widget.businessEntity.email),
                      SizedBox(height: h * 0.01),
                      _buildInfoRow(
                        'Phone:',
                        widget.businessEntity.phoneNumber,
                      ),
                      if (widget.businessEntity.address != null &&
                          widget.businessEntity.address!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: _buildInfoRow(
                            'Address:',
                            widget.businessEntity.address!,
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: h * 0.04),

                /// DOCUMENT REQUIREMENTS
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Document Requirements:',
                    style: GoogleFonts.crimsonPro(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0B3D0B),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.02),
                Text(
                  'Please upload one of the following documents:',
                  style: GoogleFonts.crimsonPro(
                    fontSize: w * 0.045,
                    color: const Color(0xFF777777),
                  ),
                ),
                SizedBox(height: h * 0.015),
                _buildRequirementItem('Business Registration Certificate'),
                _buildRequirementItem('Tax Identification Certificate'),
                _buildRequirementItem('Trade License'),
                _buildRequirementItem('Any official business document'),

                SizedBox(height: h * 0.02),
                Text(
                  'Supported formats: PDF, DOC, DOCX, JPG, PNG',
                  style: GoogleFonts.crimsonPro(
                    fontSize: w * 0.04,
                    color: const Color(0xFF777777),
                    fontStyle: FontStyle.italic,
                  ),
                ),

                SizedBox(height: h * 0.04),

                /// DOCUMENT UPLOAD AREA
                GestureDetector(
                  onTap: _pickDocument,
                  child: Container(
                    width: double.infinity,
                    height: h * 0.2,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9E9E9).withOpacity(0.45),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF777777).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _selectedDocument == null
                              ? Icons.cloud_upload_outlined
                              : Icons.file_present_outlined,
                          size: w * 0.15,
                          color:
                              _selectedDocument == null
                                  ? const Color(0xFF777777)
                                  : const Color(0xFF0B3D0B),
                        ),
                        SizedBox(height: h * 0.015),
                        Text(
                          _selectedDocument == null
                              ? 'Tap to select document'
                              : 'Selected: ${_selectedDocument!.path.split('/').last}',
                          style: GoogleFonts.crimsonPro(
                            fontSize: w * 0.045,
                            color:
                                _selectedDocument == null
                                    ? const Color(0xFF777777)
                                    : const Color(0xFF0B3D0B),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_selectedDocument != null) ...[
                          SizedBox(height: h * 0.01),
                          Text(
                            'Tap to change document',
                            style: GoogleFonts.crimsonPro(
                              fontSize: w * 0.035,
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                SizedBox(height: h * 0.05),

                /// UPLOAD BUTTON
                SizedBox(
                  width: w * 0.6,
                  height: h * 0.065,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _uploadDocument,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B3D0B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _isUploading
                            ? SizedBox(
                              width: w * 0.05,
                              height: w * 0.05,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              "Upload Document",
                              style: GoogleFonts.crimsonPro(
                                fontSize: w * 0.055,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),

                SizedBox(height: h * 0.02),

                /// BACK TO LOGIN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Back to ",
                      style: GoogleFonts.crimsonPro(
                        fontSize: w * 0.04,
                        color: const Color(0xFF7B7979),
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          () => Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst),
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
    );
  }
}
