import 'dart:io';

import 'package:agrix/core/api/api_client.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/datasource/business_product_datasource.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/model/business_product_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessProductRemoteDatasourceProvider =
    Provider<IProductRemoteDatasource>((ref) {
      return BusinessProductRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
      );
    });

class BusinessProductRemoteDatasource implements IProductRemoteDatasource {
  final ApiClient _apiClient;

  BusinessProductRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<ProductApiModel> addProduct({
    required Map<String, dynamic> productData,
    required String token,
    String? imagePath,
  }) async {
    try {
      // Create FormData for multipart request
      FormData formData;

      if (imagePath != null && File(imagePath).existsSync()) {
        final file = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        );

        formData = FormData.fromMap({...productData, 'image': file});
      } else {
        formData = FormData.fromMap(productData);
      }

      // Add authorization header
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      );

      final response = await _apiClient.post(
        ApiEndpoints.products,
        data: formData,
        options: options,
      );

      if (response.data['success'] == true) {
        final data = response.data as Map<String, dynamic>;
        return ProductApiModel.fromJson(data);
      }

      throw Exception('Product creation failed: ${response.data['message']}');
    } on DioException catch (e) {
      throw Exception(
        'Product creation failed: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<List<ProductApiModel>> getBusinessProducts(String token) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.get(
        ApiEndpoints.businessProducts,
        options: options,
      );

      if (response.data['success'] == true) {
        final data = response.data as Map<String, dynamic>;
        final productsData = data['products'] as List<dynamic>;

        return productsData
            .map<ProductApiModel>(
              (productJson) =>
                  ProductApiModel.fromJson(productJson as Map<String, dynamic>),
            )
            .toList();
      }

      throw Exception('Failed to fetch products: ${response.data['message']}');
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch products: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<ProductApiModel> getProductById({
    required String productId,
    required String token,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.get(
        '${ApiEndpoints.products}/$productId',
        options: options,
      );

      if (response.data['success'] == true) {
        final data = response.data as Map<String, dynamic>;
        return ProductApiModel.fromJson(data);
      }

      throw Exception('Failed to fetch product: ${response.data['message']}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Product not found');
      }
      throw Exception(
        'Failed to fetch product: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<ProductApiModel> updateProduct({
    required String productId,
    required Map<String, dynamic> productData,
    required String token,
    String? imagePath,
  }) async {
    try {
      // Create FormData for multipart request
      FormData formData;

      if (imagePath != null && File(imagePath).existsSync()) {
        final file = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        );

        formData = FormData.fromMap({...productData, 'image': file});
      } else {
        formData = FormData.fromMap(productData);
      }

      // Add authorization header
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      );

      final response = await _apiClient.put(
        '${ApiEndpoints.products}/$productId',
        data: formData,
        options: options,
      );

      if (response.data['success'] == true) {
        final data = response.data as Map<String, dynamic>;
        return ProductApiModel.fromJson(data);
      }

      throw Exception('Product update failed: ${response.data['message']}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Product not found');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Access denied');
      }
      throw Exception(
        'Product update failed: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<bool> deleteProduct({
    required String productId,
    required String token,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.delete(
        '${ApiEndpoints.products}/$productId',
        options: options,
      );

      if (response.data['success'] == true) {
        return true;
      }

      throw Exception('Product deletion failed: ${response.data['message']}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Product not found');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Access denied');
      }
      throw Exception(
        'Product deletion failed: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }
}
