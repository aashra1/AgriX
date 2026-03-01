import 'package:agrix/core/api/api_client.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/data/model/business_transaction_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class IBusinessWalletRemoteDatasource {
  Future<BusinessWalletApiModel> getBusinessWalletBalance({
    required String token,
  });

  Future<List<BusinessTransactionApiModel>> getBusinessTransactions({
    required String token,
    int page,
    int limit,
  });

  Future<Map<String, dynamic>> getPaginationInfo();
}

final businessWalletRemoteDatasourceProvider =
    Provider<IBusinessWalletRemoteDatasource>((ref) {
      return BusinessWalletRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
      );
    });

class BusinessWalletRemoteDatasource
    implements IBusinessWalletRemoteDatasource {
  final ApiClient _apiClient;
  Map<String, dynamic>? _lastPagination;

  BusinessWalletRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<BusinessWalletApiModel> getBusinessWalletBalance({
    required String token,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.get(
        ApiEndpoints.businessWalletBalance,
        options: options,
      );

      if (response.data['success'] == true) {
        return BusinessWalletApiModel.fromJson(response.data['data']);
      }

      throw Exception(
        'Failed to fetch wallet balance: ${response.data['message']}',
      );
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch wallet balance: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<List<BusinessTransactionApiModel>> getBusinessTransactions({
    required String token,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.get(
        '${ApiEndpoints.businessWalletTransactions}?page=$page&limit=$limit',
        options: options,
      );

      if (response.data['success'] == true) {
        _lastPagination = response.data['pagination'] as Map<String, dynamic>?;

        final transactionsData = response.data['data'] as List<dynamic>;
        return transactionsData
            .map(
              (tx) => BusinessTransactionApiModel.fromJson(
                tx as Map<String, dynamic>,
              ),
            )
            .toList();
      }

      throw Exception(
        'Failed to fetch transactions: ${response.data['message']}',
      );
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch transactions: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getPaginationInfo() async {
    return _lastPagination ?? {};
  }
}
