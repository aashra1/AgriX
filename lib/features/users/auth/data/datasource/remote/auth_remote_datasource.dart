import 'dart:io';

import 'package:agrix/core/api/api_client.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/features/users/auth/data/datasource/auth_datasource.dart';
import 'package:agrix/features/users/auth/data/models/auth_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// User Remote Datasource Provider
final authRemoteDatasourceProvider = Provider<IAuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;

  @override
  Future<AuthApiModel?> loginUser(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.userLogin,
      data: {'email': email, 'password': password},
    );

    if (response.data['success'] == true) {
      final data = response.data as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);
      final token = data['token'] as String?;

      if (user.id == null) {
        throw Exception('User ID is null in response');
      }

      // Save user session with token
      await _userSessionService.saveUserSession(
        authId: user.id!,
        email: user.email,
        fullName: user.fullName,
        token: token,
      );

      return user;
    }
    return null;
  }

  @override
  Future<AuthApiModel> registerUser(
    AuthApiModel model, {
    String? imagePath,
  }) async {
    dynamic data = model.toJson();
    if (imagePath != null && imagePath.isNotEmpty && File(imagePath).existsSync()) {
      final imageFile = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );
      data = FormData.fromMap({...model.toJson(), 'profilePicture': imageFile});
    }

    final response = await _apiClient.post(
      ApiEndpoints.userRegister,
      data: data,
    );

    if (response.data['success'] == true) {
      final data = response.data as Map<String, dynamic>;
      return AuthApiModel.fromJson(data);
    }

    throw Exception('Registration failed: ${response.data['message']}');
  }
}
