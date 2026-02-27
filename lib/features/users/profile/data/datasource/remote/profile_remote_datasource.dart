import 'dart:io';

import 'package:agrix/core/api/api_client.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/features/users/profile/data/datasource/profile_datasource.dart';
import 'package:agrix/features/users/profile/data/model/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileRemoteDatasourceProvider =
    Provider<IUserProfileRemoteDatasource>((ref) {
      return UserProfileRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
      );
    });

class UserProfileRemoteDatasource implements IUserProfileRemoteDatasource {
  final ApiClient _apiClient;

  UserProfileRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<UserProfileApiModel> getUserProfile({required String token}) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.get(
        ApiEndpoints.userProfile,
        options: options,
      );

      if (response.data != null) {
        return UserProfileApiModel.fromJson(response.data);
      }

      throw Exception('Failed to fetch user profile');
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch user profile: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<UserProfileApiModel> updateUserProfile({
    required String token,
    required Map<String, dynamic> profileData,
    String? imagePath,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      dynamic data;
      if (imagePath != null && File(imagePath).existsSync()) {
        final file = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        );
        data = FormData.fromMap({...profileData, 'profilePicture': file});
      } else {
        data = profileData;
      }

      final response = await _apiClient.put(
        ApiEndpoints.editUserProfile,
        data: data,
        options: options,
      );

      if (response.data['success'] == true) {
        return UserProfileApiModel.fromJson(
          response.data['user'] ?? response.data,
        );
      }

      throw Exception(
        'Failed to update user profile: ${response.data['message']}',
      );
    } on DioException catch (e) {
      throw Exception(
        'Failed to update user profile: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<bool> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final data = {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };

      final response = await _apiClient.put(
        ApiEndpoints.changePassword,
        data: data,
        options: options,
      );

      if (response.data['success'] == true) {
        return true;
      }

      throw Exception('Failed to change password: ${response.data['message']}');
    } on DioException catch (e) {
      throw Exception(
        'Failed to change password: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }
}
