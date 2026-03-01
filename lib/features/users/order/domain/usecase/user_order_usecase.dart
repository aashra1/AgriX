import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/usecases/app_usecases.dart';
import 'package:agrix/features/users/order/data/repository/user_order_repository.dart';
import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:agrix/features/users/order/domain/repository/user_order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createUserOrderUsecaseProvider = Provider<CreateUserOrderUsecase>((ref) {
  final repository = ref.read(userOrderRepositoryProvider);
  return CreateUserOrderUsecase(repository: repository);
});

final getUserOrdersUsecaseProvider = Provider<GetUserOrdersUsecase>((ref) {
  final repository = ref.read(userOrderRepositoryProvider);
  return GetUserOrdersUsecase(repository: repository);
});

final getUserOrderByIdUsecaseProvider = Provider<GetUserOrderByIdUsecase>((
  ref,
) {
  final repository = ref.read(userOrderRepositoryProvider);
  return GetUserOrderByIdUsecase(repository: repository);
});

class CreateUserOrderUsecaseParams extends Equatable {
  final String token;
  final Map<String, dynamic> orderData;

  const CreateUserOrderUsecaseParams({
    required this.token,
    required this.orderData,
  });

  @override
  List<Object?> get props => [token, orderData];
}

class CreateUserOrderUsecase
    implements
        UsecaseWithParams<UserOrderEntity, CreateUserOrderUsecaseParams> {
  final IUserOrderRepository _repository;

  CreateUserOrderUsecase({required IUserOrderRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, UserOrderEntity>> call(
    CreateUserOrderUsecaseParams params,
  ) {
    return _repository.createOrder(
      token: params.token,
      orderData: params.orderData,
    );
  }
}

class GetUserOrdersUsecaseParams extends Equatable {
  final String token;
  final int page;
  final int limit;
  final bool refresh;

  const GetUserOrdersUsecaseParams({
    required this.token,
    this.page = 1,
    this.limit = 10,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [token, page, limit, refresh];
}

class GetUserOrdersUsecase
    implements
        UsecaseWithParams<List<UserOrderEntity>, GetUserOrdersUsecaseParams> {
  final IUserOrderRepository _repository;

  GetUserOrdersUsecase({required IUserOrderRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<UserOrderEntity>>> call(
    GetUserOrdersUsecaseParams params,
  ) {
    return _repository.getUserOrders(
      token: params.token,
      page: params.page,
      limit: params.limit,
      refresh: params.refresh,
    );
  }
}

class GetUserOrderByIdUsecaseParams extends Equatable {
  final String token;
  final String orderId;

  const GetUserOrderByIdUsecaseParams({
    required this.token,
    required this.orderId,
  });

  @override
  List<Object?> get props => [token, orderId];
}

class GetUserOrderByIdUsecase
    implements
        UsecaseWithParams<UserOrderEntity, GetUserOrderByIdUsecaseParams> {
  final IUserOrderRepository _repository;

  GetUserOrderByIdUsecase({required IUserOrderRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, UserOrderEntity>> call(
    GetUserOrderByIdUsecaseParams params,
  ) {
    return _repository.getOrderById(
      token: params.token,
      orderId: params.orderId,
    );
  }
}
