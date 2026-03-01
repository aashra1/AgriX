import 'package:agrix/core/api/api_client.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/features/users/payment/data/datasource/user_payment_datasource.dart';
import 'package:agrix/features/users/payment/data/model/user_payment_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userPaymentRemoteDatasourceProvider =
    Provider<IUserPaymentRemoteDatasource>((ref) {
      return UserPaymentRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
      );
    });

class UserPaymentRemoteDatasource implements IUserPaymentRemoteDatasource {
  final ApiClient _apiClient;

  UserPaymentRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<InitiatePaymentApiModel> initiateKhaltiPayment({
    required String token,
    required String orderId,
    required double amount,
    required String returnUrl,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final data = {
        'orderId': orderId,
        'amount': amount,
        'returnUrl': returnUrl,
      };

      final response = await _apiClient.post(
        ApiEndpoints.initiateKhalti,
        data: data,
        options: options,
      );

      if (response.data['success'] == true) {
        return InitiatePaymentApiModel.fromJson(response.data);
      }

      throw Exception(
        'Failed to initiate payment: ${response.data['message']}',
      );
    } on DioException catch (e) {
      throw Exception(
        'Failed to initiate payment: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<UserPaymentApiModel> verifyKhaltiPayment({
    required String token,
    required String pidx,
    required String orderId,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final data = {'pidx': pidx, 'orderId': orderId};

      final response = await _apiClient.post(
        ApiEndpoints.verifyKhalti,
        data: data,
        options: options,
      );

      if (response.data['success'] == true) {
        return UserPaymentApiModel.fromJson(response.data);
      }

      throw Exception('Failed to verify payment: ${response.data['message']}');
    } on DioException catch (e) {
      throw Exception(
        'Failed to verify payment: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<UserPaymentApiModel> getPaymentByOrderId({
    required String token,
    required String orderId,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.get(
        ApiEndpoints.paymentByOrderId(orderId),
        options: options,
      );

      if (response.data['success'] == true) {
        return UserPaymentApiModel.fromJson(response.data);
      }

      throw Exception('Failed to fetch payment: ${response.data['message']}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Payment not found');
      }
      throw Exception(
        'Failed to fetch payment: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<List<UserPaymentApiModel>> getUserPayments({
    required String token,
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      String url = '${ApiEndpoints.userPayments}?page=$page&limit=$limit';
      if (status != null && status.isNotEmpty) {
        url += '&status=$status';
      }

      final response = await _apiClient.get(url, options: options);

      if (response.data['success'] == true) {
        final paymentsData = response.data['data'] as List<dynamic>;
        return paymentsData
            .map(
              (payment) =>
                  UserPaymentApiModel.fromJson(payment as Map<String, dynamic>),
            )
            .toList();
      }

      throw Exception('Failed to fetch payments: ${response.data['message']}');
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch payments: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }
}
