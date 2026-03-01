import 'package:agrix/core/api/api_client.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/data/datasource/business_order_datasource.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/data/model/business_order_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessOrderRemoteDatasourceProvider =
    Provider<IBusinessOrderRemoteDatasource>((ref) {
      return BusinessOrderRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
      );
    });

class BusinessOrderRemoteDatasource implements IBusinessOrderRemoteDatasource {
  final ApiClient _apiClient;

  BusinessOrderRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  // lib/features/business/business_dashboard/order/data/datasource/remote/business_order_remote_datasource.dart
  @override
  Future<List<BusinessOrderApiModel>> getBusinessOrders({
    required String token,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      // Use the correct endpoint - businessId comes from auth token on backend
      final response = await _apiClient.get(
        '${ApiEndpoints.businessOrders}?page=$page&limit=$limit',
        options: options,
      );

      if (response.data['success'] == true) {
        final ordersData = response.data['orders'] as List<dynamic>;
        return ordersData
            .map(
              (order) =>
                  BusinessOrderApiModel.fromJson(order as Map<String, dynamic>),
            )
            .toList();
      }

      throw Exception(
        'Failed to fetch business orders: ${response.data['message']}',
      );
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch business orders: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<BusinessOrderApiModel> getOrderById({
    required String orderId,
    required String token,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.get(
        '${ApiEndpoints.orders}/$orderId',
        options: options,
      );

      if (response.data['success'] == true) {
        final data = response.data['order'] as Map<String, dynamic>;
        return BusinessOrderApiModel.fromJson(data);
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

  @override
  Future<BusinessOrderApiModel> updateOrderStatus({
    required String orderId,
    required String orderStatus,
    String? trackingNumber,
    required String token,
  }) async {
    try {
      final data = {
        'orderStatus': orderStatus,
        if (trackingNumber != null) 'trackingNumber': trackingNumber,
      };

      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.put(
        '${ApiEndpoints.orders}/$orderId/status',
        data: data,
        options: options,
      );

      if (response.data['success'] == true) {
        final data = response.data['order'] as Map<String, dynamic>;
        return BusinessOrderApiModel.fromJson(data);
      }

      throw Exception(
        'Order status update failed: ${response.data['message']}',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Order not found');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Access denied');
      }
      throw Exception(
        'Order status update failed: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<BusinessOrderApiModel> updatePaymentStatus({
    required String orderId,
    required String paymentStatus,
    required String token,
  }) async {
    try {
      final data = {'paymentStatus': paymentStatus};
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.put(
        '${ApiEndpoints.orders}/$orderId/payment',
        data: data,
        options: options,
      );

      if (response.data['success'] == true) {
        final data = response.data['order'] as Map<String, dynamic>;
        return BusinessOrderApiModel.fromJson(data);
      }

      throw Exception(
        'Payment status update failed: ${response.data['message']}',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Order not found');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Access denied');
      }
      throw Exception(
        'Payment status update failed: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }
}
