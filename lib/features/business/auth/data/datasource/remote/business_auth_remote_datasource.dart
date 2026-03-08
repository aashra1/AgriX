import 'dart:io';

import 'package:agrix/core/api/api_client.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/features/business/auth/data/datasource/business_auth_datasource.dart';
import 'package:agrix/features/business/auth/data/models/business_auth_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Business Remote Datasource Provider
final businessAuthRemoteDatasourceProvider =
    Provider<IBusinessAuthRemoteDatasource>((ref) {
      return BusinessAuthRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
        userSessionService: ref.read(userSessionServiceProvider),
      );
    });

class BusinessAuthRemoteDatasource implements IBusinessAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  BusinessAuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;

  @override
  Future<BusinessAuthApiModel?> loginBusiness(
    String email,
    String password,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.businessLogin,
      data: {'email': email, 'password': password},
    );

    if (response.data['success'] == true) {
      final data = response.data as Map<String, dynamic>;
      final business = BusinessAuthApiModel.fromJson(data);
      final token = data['token'] as String?;

      if (business.id == null) {
        throw Exception('Business ID is null in response');
      }

      await _userSessionService.saveUserSession(
        authId: business.id!,
        email: business.email,
        fullName: business.businessName,
        token: token,
      );

      return business;
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> registerBusiness(
    BusinessAuthApiModel model,
    {String? imagePath}
  ) async {
    dynamic data = model.toJson();
    if (imagePath != null &&
        imagePath.isNotEmpty &&
        File(imagePath).existsSync()) {
      final imageFile = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );
      data = FormData.fromMap({
        ...model.toJson(),
        'profilePicture': imageFile,
      });
    }

    final response = await _apiClient.post(
      ApiEndpoints.businessRegister,
      data: data,
    );

    if (response.data['success'] == true) {
      final data = response.data as Map<String, dynamic>;
      final business = BusinessAuthApiModel.fromJson(data);
      final tempToken = data['tempToken'] as String?;
      final message = data['message'] as String? ?? 'Registration successful';

      if (tempToken != null && business.id != null) {
        await _userSessionService.saveUserSession(
          authId: business.id!,
          email: business.email,
          fullName: business.businessName,
          token: tempToken,
        );
      }

      return {
        'business': business.toBusinessAuthEntity(),
        'tempToken': tempToken,
        'message': message,
      };
    }

    throw Exception('Registration failed: ${response.data['message']}');
  }

  @override
  Future<BusinessAuthApiModel> uploadBusinessDocument({
    required String businessId,
    required String documentPath,
    required String token,
  }) async {
    // Validate file exists
    final file = File(documentPath);
    if (!await file.exists()) {
      throw Exception('File does not exist: $documentPath');
    }

    final fileName = file.path.split('/').last;

    // Create multipart form data
    final formData = FormData.fromMap({
      'businessId': businessId,
      'document': await MultipartFile.fromFile(
        documentPath,
        filename: fileName,
      ),
    });

    final response = await _apiClient.post(
      ApiEndpoints.businessUploadDocument,
      data: formData,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    if (response.data['success'] == true) {
      final data = response.data as Map<String, dynamic>;
      return BusinessAuthApiModel.fromJson(data);
    }

    throw Exception('Document upload failed: ${response.data['message']}');
  }
}
