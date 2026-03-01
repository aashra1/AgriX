import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/usecases/app_usecases.dart';
import 'package:agrix/features/users/payment/data/repository/user_payment_repository.dart';
import 'package:agrix/features/users/payment/domain/entity/user_payment_entity.dart';
import 'package:agrix/features/users/payment/domain/repository/user_payment_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initiateKhaltiPaymentUsecaseProvider =
    Provider<InitiateKhaltiPaymentUsecase>((ref) {
      final repository = ref.read(userPaymentRepositoryProvider);
      return InitiateKhaltiPaymentUsecase(repository: repository);
    });

final verifyKhaltiPaymentUsecaseProvider = Provider<VerifyKhaltiPaymentUsecase>(
  (ref) {
    final repository = ref.read(userPaymentRepositoryProvider);
    return VerifyKhaltiPaymentUsecase(repository: repository);
  },
);

final getPaymentByOrderIdUsecaseProvider = Provider<GetPaymentByOrderIdUsecase>(
  (ref) {
    final repository = ref.read(userPaymentRepositoryProvider);
    return GetPaymentByOrderIdUsecase(repository: repository);
  },
);

final getUserPaymentsUsecaseProvider = Provider<GetUserPaymentsUsecase>((ref) {
  final repository = ref.read(userPaymentRepositoryProvider);
  return GetUserPaymentsUsecase(repository: repository);
});

class InitiateKhaltiPaymentUsecaseParams extends Equatable {
  final String token;
  final String orderId;
  final double amount;
  final String returnUrl;

  const InitiateKhaltiPaymentUsecaseParams({
    required this.token,
    required this.orderId,
    required this.amount,
    required this.returnUrl,
  });

  @override
  List<Object?> get props => [token, orderId, amount, returnUrl];
}

class InitiateKhaltiPaymentUsecase
    implements
        UsecaseWithParams<
          InitiatePaymentEntity,
          InitiateKhaltiPaymentUsecaseParams
        > {
  final IUserPaymentRepository _repository;

  InitiateKhaltiPaymentUsecase({required IUserPaymentRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, InitiatePaymentEntity>> call(
    InitiateKhaltiPaymentUsecaseParams params,
  ) {
    return _repository.initiateKhaltiPayment(
      token: params.token,
      orderId: params.orderId,
      amount: params.amount,
      returnUrl: params.returnUrl,
    );
  }
}

class VerifyKhaltiPaymentUsecaseParams extends Equatable {
  final String token;
  final String pidx;
  final String orderId;

  const VerifyKhaltiPaymentUsecaseParams({
    required this.token,
    required this.pidx,
    required this.orderId,
  });

  @override
  List<Object?> get props => [token, pidx, orderId];
}

class VerifyKhaltiPaymentUsecase
    implements
        UsecaseWithParams<UserPaymentEntity, VerifyKhaltiPaymentUsecaseParams> {
  final IUserPaymentRepository _repository;

  VerifyKhaltiPaymentUsecase({required IUserPaymentRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, UserPaymentEntity>> call(
    VerifyKhaltiPaymentUsecaseParams params,
  ) {
    return _repository.verifyKhaltiPayment(
      token: params.token,
      pidx: params.pidx,
      orderId: params.orderId,
    );
  }
}

class GetPaymentByOrderIdUsecaseParams extends Equatable {
  final String token;
  final String orderId;

  const GetPaymentByOrderIdUsecaseParams({
    required this.token,
    required this.orderId,
  });

  @override
  List<Object?> get props => [token, orderId];
}

class GetPaymentByOrderIdUsecase
    implements
        UsecaseWithParams<UserPaymentEntity, GetPaymentByOrderIdUsecaseParams> {
  final IUserPaymentRepository _repository;

  GetPaymentByOrderIdUsecase({required IUserPaymentRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, UserPaymentEntity>> call(
    GetPaymentByOrderIdUsecaseParams params,
  ) {
    return _repository.getPaymentByOrderId(
      token: params.token,
      orderId: params.orderId,
    );
  }
}

class GetUserPaymentsUsecaseParams extends Equatable {
  final String token;
  final int page;
  final int limit;
  final String? status;

  const GetUserPaymentsUsecaseParams({
    required this.token,
    this.page = 1,
    this.limit = 10,
    this.status,
  });

  @override
  List<Object?> get props => [token, page, limit, status];
}

class GetUserPaymentsUsecase
    implements
        UsecaseWithParams<
          List<UserPaymentEntity>,
          GetUserPaymentsUsecaseParams
        > {
  final IUserPaymentRepository _repository;

  GetUserPaymentsUsecase({required IUserPaymentRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<UserPaymentEntity>>> call(
    GetUserPaymentsUsecaseParams params,
  ) {
    return _repository.getUserPayments(
      token: params.token,
      page: params.page,
      limit: params.limit,
      status: params.status,
    );
  }
}
