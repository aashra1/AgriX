import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/usecases/app_usecases.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/data/repository/business_wallet_repository.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/domain/repository/business_transaction_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getWalletBalanceUsecaseProvider = Provider<GetWalletBalanceUsecase>((
  ref,
) {
  final repository = ref.read(businessWalletRepositoryProvider);
  return GetWalletBalanceUsecase(repository: repository);
});

final getTransactionsUsecaseProvider = Provider<GetTransactionsUsecase>((ref) {
  final repository = ref.read(businessWalletRepositoryProvider);
  return GetTransactionsUsecase(repository: repository);
});

class GetWalletBalanceUsecaseParams extends Equatable {
  final String token;
  const GetWalletBalanceUsecaseParams({required this.token});

  @override
  List<Object?> get props => [token];
}

class GetWalletBalanceUsecase
    implements UsecaseWithParams<double, GetWalletBalanceUsecaseParams> {
  final IBusinessWalletRepository _repository;

  GetWalletBalanceUsecase({required IBusinessWalletRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, double>> call(GetWalletBalanceUsecaseParams params) {
    return _repository.getWalletBalance(token: params.token);
  }
}

class GetTransactionsUsecaseParams extends Equatable {
  final String token;
  final int page;
  final int limit;

  const GetTransactionsUsecaseParams({
    required this.token,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [token, page, limit];
}

class GetTransactionsUsecase
    implements
        UsecaseWithParams<Map<String, dynamic>, GetTransactionsUsecaseParams> {
  final IBusinessWalletRepository _repository;

  GetTransactionsUsecase({required IBusinessWalletRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    GetTransactionsUsecaseParams params,
  ) async {
    final transactionsResult = await _repository.getTransactions(
      token: params.token,
      page: params.page,
      limit: params.limit,
    );

    return transactionsResult.fold((failure) => Left(failure), (
      transactions,
    ) async {
      final paginationResult = await _repository.getPagination();
      return paginationResult.fold(
        (failure) => Left(failure),
        (pagination) =>
            Right({'transactions': transactions, 'pagination': pagination}),
      );
    });
  }
}
