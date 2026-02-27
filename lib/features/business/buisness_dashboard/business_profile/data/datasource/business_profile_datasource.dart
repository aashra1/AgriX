import 'dart:io';

import 'package:agrix/core/api/api_client.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/features/business/buisness_dashboard/business_profile/data/model/business_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class IBusinessProfileRemoteDatasource {
  Future<BusinessProfileApiModel> getBusinessProfile({required String token});

  Future<BusinessProfileApiModel> updateBusinessProfile({
    required String token,
    required Map<String, dynamic> profileData,
    String? imagePath,
  });
}

final businessProfileRemoteDatasourceProvider =
    Provider<IBusinessProfileRemoteDatasource>((ref) {
      return BusinessProfileRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
      );
    });

class BusinessProfileRemoteDatasource
    implements IBusinessProfileRemoteDatasource {
  final ApiClient _apiClient;

  BusinessProfileRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<BusinessProfileApiModel> getBusinessProfile({
    required String token,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.get(
        ApiEndpoints.businessProfile,
        options: options,
      );

      if (response.data != null) {
        return BusinessProfileApiModel.fromJson(response.data);
      }

      throw Exception('Failed to fetch business profile');
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch business profile: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<BusinessProfileApiModel> updateBusinessProfile({
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
        ApiEndpoints.editBusinessProfile,
        data: data,
        options: options,
      );

      if (response.data != null) {
        return BusinessProfileApiModel.fromJson(
          response.data['business'] ?? response.data,
        );
      }

      throw Exception('Failed to update business profile');
    } on DioException catch (e) {
      throw Exception(
        'Failed to update business profile: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }
}
