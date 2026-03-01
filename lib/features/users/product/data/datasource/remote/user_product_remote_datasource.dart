import 'package:agrix/core/api/api_client.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/features/users/product/data/datasource/user_product_datasource.dart';
import 'package:agrix/features/users/product/data/model/user_product_api_model.dart';
import 'package:agrix/features/users/product/data/model/user_product_hive_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProductRemoteDatasourceProvider =
    Provider<IUserProductRemoteDatasource>((ref) {
      return UserProductRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
      );
    });

class UserProductRemoteDatasource implements IUserProductRemoteDatasource {
  final ApiClient _apiClient;

  UserProductRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<UserProductHiveModel>> getAllProducts({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.products}?page=$page&limit=$limit',
      );

      if (response.data['success'] == true) {
        final productsData = response.data['products'] as List<dynamic>;
        final apiModels =
            productsData
                .map(
                  (product) => UserProductApiModel.fromJson(
                    product as Map<String, dynamic>,
                  ),
                )
                .toList();

        return apiModels
            .map((model) => UserProductHiveModel.fromEntity(model.toEntity()))
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
  Future<List<UserProductHiveModel>> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.products}/category/$categoryId?page=$page&limit=$limit',
      );

      if (response.data['success'] == true) {
        final productsData = response.data['products'] as List<dynamic>;
        final apiModels =
            productsData
                .map(
                  (product) => UserProductApiModel.fromJson(
                    product as Map<String, dynamic>,
                  ),
                )
                .toList();

        return apiModels
            .map((model) => UserProductHiveModel.fromEntity(model.toEntity()))
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
  Future<UserProductHiveModel> getProductById({
    required String productId,
  }) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.products}/$productId',
      );

      if (response.data['success'] == true) {
        final productData = response.data['product'] as Map<String, dynamic>;
        final apiModel = UserProductApiModel.fromJson(productData);
        return UserProductHiveModel.fromEntity(apiModel.toEntity());
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
  Future<List<UserProductHiveModel>> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.products}/search?q=$query&page=$page&limit=$limit',
      );

      if (response.data['success'] == true) {
        final productsData = response.data['products'] as List<dynamic>;
        final apiModels =
            productsData
                .map(
                  (product) => UserProductApiModel.fromJson(
                    product as Map<String, dynamic>,
                  ),
                )
                .toList();

        return apiModels
            .map((model) => UserProductHiveModel.fromEntity(model.toEntity()))
            .toList();
      }

      throw Exception('Failed to search products: ${response.data['message']}');
    } on DioException catch (e) {
      throw Exception(
        'Failed to search products: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }
}
