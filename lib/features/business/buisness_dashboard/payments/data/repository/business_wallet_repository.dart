import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/data/datasource/remote/business_wallet_remote_datasource.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/data/model/business_transaction_model.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/domain/entity/business_transaction_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/domain/repository/business_transaction_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessWalletRepositoryProvider = Provider<IBusinessWalletRepository>((
  ref,
) {
  final remoteDatasource = ref.read(businessWalletRemoteDatasourceProvider);
  return BusinessWalletRepository(remoteDatasource: remoteDatasource);
});

class BusinessWalletRepository implements IBusinessWalletRepository {
  final IBusinessWalletRemoteDatasource _remoteDatasource;

  BusinessWalletRepository({
    required IBusinessWalletRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, double>> getWalletBalance({
    required String token,
  }) async {
    try {
      final wallet = await _remoteDatasource.getBusinessWalletBalance(
        token: token,
      );
      return Right(wallet.balance);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? 'Failed to fetch wallet balance',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BusinessTransactionEntity>>> getTransactions({
    required String token,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final apiTransactions = await _remoteDatasource.getBusinessTransactions(
        token: token,
        page: page,
        limit: limit,
      );

      final entities = BusinessTransactionApiModel.toEntityList(
        apiTransactions,
      );
      return Right(entities);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? 'Failed to fetch transactions',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getPagination() async {
    try {
      final pagination = await _remoteDatasource.getPaginationInfo();
      return Right({
        'page': pagination['page'] as int? ?? 1,
        'limit': pagination['limit'] as int? ?? 10,
        'total': pagination['total'] as int? ?? 0,
        'pages': pagination['pages'] as int? ?? 1,
      });
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
