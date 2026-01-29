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

      // Save business session with token
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
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.businessRegister,
      data: model.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data as Map<String, dynamic>;
      final business = BusinessAuthApiModel.fromJson(data);
      final tempToken = data['tempToken'] as String?;

      return {
        'business': business.toBusinessAuthEntity(),
        'tempToken': tempToken,
        'message': data['message'] as String? ?? 'Registration successful',
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
    final response = await _apiClient.post(
      ApiEndpoints.businessUploadDocument,
      data: {
        'businessId': businessId,
        'documentPath': documentPath,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    if (response.data['success'] == true) {
      final data = response.data as Map<String, dynamic>;
      return BusinessAuthApiModel.fromJson(data);
    }

    throw Exception('Document upload failed: ${response.data['message']}');
  }
}
  