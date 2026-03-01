import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/domain/entity/business_transaction_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IBusinessWalletRepository {
  Future<Either<Failure, double>> getWalletBalance({required String token});

  Future<Either<Failure, List<BusinessTransactionEntity>>> getTransactions({
    required String token,
    int page,
    int limit,
  });

  Future<Either<Failure, Map<String, int>>> getPagination();
}
