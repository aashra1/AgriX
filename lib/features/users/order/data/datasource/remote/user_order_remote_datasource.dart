import 'package:agrix/core/api/api_client.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/features/users/order/data/datasource/user_order_datasource.dart';
import 'package:agrix/features/users/order/data/model/user_order_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userOrderRemoteDatasourceProvider = Provider<IUserOrderRemoteDatasource>((
  ref,
) {
  return UserOrderRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class UserOrderRemoteDatasource implements IUserOrderRemoteDatasource {
  final ApiClient _apiClient;

  UserOrderRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<UserOrderApiModel> createOrder({
    required String token,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.post(
        ApiEndpoints.orders,
        data: orderData,
        options: options,
      );

      if (response.data['success'] == true) {
        return UserOrderApiModel.fromJson(response.data);
      }

      throw Exception('Failed to create order: ${response.data['message']}');
    } on DioException catch (e) {
      throw Exception(
        'Failed to create order: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<List<UserOrderApiModel>> getUserOrders({
    required String token,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.get(
        '${ApiEndpoints.userOrders}?page=$page&limit=$limit',
        options: options,
      );

      if (response.data['success'] == true) {
        final ordersData = response.data['orders'] as List<dynamic>;
        return ordersData
            .map(
              (order) =>
                  UserOrderApiModel.fromJson(order as Map<String, dynamic>),
            )
            .toList();
      }

      throw Exception('Failed to fetch orders: ${response.data['message']}');
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch orders: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<UserOrderApiModel> getOrderById({
    required String token,
    required String orderId,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.get(
        ApiEndpoints.orderById(orderId),
        options: options,
      );

      if (response.data['success'] == true) {
        return UserOrderApiModel.fromJson(response.data);
      }

      throw Exception('Failed to fetch order: ${response.data['message']}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Order not found');
      }
      throw Exception(
        'Failed to fetch order: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }
}
