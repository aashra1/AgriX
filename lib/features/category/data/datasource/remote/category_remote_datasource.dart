import 'package:agrix/core/api/api_client.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/features/category/data/datasource/category_datasource.dart';
import 'package:agrix/features/category/data/model/category_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRemoteDatasourceProvider = Provider<ICategoryRemoteDatasource>((
  ref,
) {
  return CategoryRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class CategoryRemoteDatasource implements ICategoryRemoteDatasource {
  final ApiClient _apiClient;

  CategoryRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<CategoryApiModel>> getCategories() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.categories);

      if (response.data['success'] == true) {
        final data = response.data as Map<String, dynamic>;
        final categoriesData = data['categories'] as List<dynamic>;

        return categoriesData
            .map<CategoryApiModel>(
              (categoryJson) => CategoryApiModel.fromJson(
                categoryJson as Map<String, dynamic>,
              ),
            )
            .toList();
      }

      throw Exception(
        'Failed to fetch categories: ${response.data['message']}',
      );
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch categories: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }
}
