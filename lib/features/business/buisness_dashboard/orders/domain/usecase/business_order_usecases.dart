// lib/features/business/business_dashboard/order/domain/usecase/business_order_usecase.dart
import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/usecases/app_usecases.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/data/repository/business_order_repository.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/domain/entity/business_order_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/domain/repository/business_order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getBusinessOrdersUsecaseProvider = Provider<GetBusinessOrdersUsecase>((
  ref,
) {
  final orderRepository = ref.read(businessOrderRepositoryProvider);
  return GetBusinessOrdersUsecase(orderRepository: orderRepository);
});

final getOrderByIdUsecaseProvider = Provider<GetOrderByIdUsecase>((ref) {
  final orderRepository = ref.read(businessOrderRepositoryProvider);
  return GetOrderByIdUsecase(orderRepository: orderRepository);
});

final updateOrderStatusUsecaseProvider = Provider<UpdateOrderStatusUsecase>((
  ref,
) {
  final orderRepository = ref.read(businessOrderRepositoryProvider);
  return UpdateOrderStatusUsecase(orderRepository: orderRepository);
});

final updatePaymentStatusUsecaseProvider = Provider<UpdatePaymentStatusUsecase>(
  (ref) {
    final orderRepository = ref.read(businessOrderRepositoryProvider);
    return UpdatePaymentStatusUsecase(orderRepository: orderRepository);
  },
);

class GetBusinessOrdersUsecaseParams extends Equatable {
  final String token;
  final String businessId;
  final int page;
  final int limit;

  const GetBusinessOrdersUsecaseParams({
    required this.token,
    required this.businessId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [token, businessId, page, limit];
}

class GetBusinessOrdersUsecase
    implements
        UsecaseWithParams<
          List<BusinessOrderEntity>,
          GetBusinessOrdersUsecaseParams
        > {
  final IBusinessOrderRepository _orderRepository;

  GetBusinessOrdersUsecase({required IBusinessOrderRepository orderRepository})
    : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, List<BusinessOrderEntity>>> call(
    GetBusinessOrdersUsecaseParams params,
  ) {
    return _orderRepository.getBusinessOrders(
      token: params.token,
      businessId: params.businessId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetOrderByIdUsecaseParams extends Equatable {
  final String orderId;
  final String token;

  const GetOrderByIdUsecaseParams({required this.orderId, required this.token});

  @override
  List<Object?> get props => [orderId, token];
}

class GetOrderByIdUsecase
    implements
        UsecaseWithParams<BusinessOrderEntity, GetOrderByIdUsecaseParams> {
  final IBusinessOrderRepository _orderRepository;

  GetOrderByIdUsecase({required IBusinessOrderRepository orderRepository})
    : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, BusinessOrderEntity>> call(
    GetOrderByIdUsecaseParams params,
  ) {
    return _orderRepository.getOrderById(
      orderId: params.orderId,
      token: params.token,
    );
  }
}

class UpdateOrderStatusUsecaseParams extends Equatable {
  final String orderId;
  final String orderStatus;
  final String? trackingNumber;
  final String token;

  const UpdateOrderStatusUsecaseParams({
    required this.orderId,
    required this.orderStatus,
    this.trackingNumber,
    required this.token,
  });

  @override
  List<Object?> get props => [orderId, orderStatus, trackingNumber, token];
}

class UpdateOrderStatusUsecase
    implements
        UsecaseWithParams<BusinessOrderEntity, UpdateOrderStatusUsecaseParams> {
  final IBusinessOrderRepository _orderRepository;

  UpdateOrderStatusUsecase({required IBusinessOrderRepository orderRepository})
    : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, BusinessOrderEntity>> call(
    UpdateOrderStatusUsecaseParams params,
  ) {
    return _orderRepository.updateOrderStatus(
      orderId: params.orderId,
      orderStatus: params.orderStatus,
      trackingNumber: params.trackingNumber,
      token: params.token,
    );
  }
}

class UpdatePaymentStatusUsecaseParams extends Equatable {
  final String orderId;
  final String paymentStatus;
  final String token;

  const UpdatePaymentStatusUsecaseParams({
    required this.orderId,
    required this.paymentStatus,
    required this.token,
  });

  @override
  List<Object?> get props => [orderId, paymentStatus, token];
}

class UpdatePaymentStatusUsecase
    implements
        UsecaseWithParams<
          BusinessOrderEntity,
          UpdatePaymentStatusUsecaseParams
        > {
  final IBusinessOrderRepository _orderRepository;

  UpdatePaymentStatusUsecase({
    required IBusinessOrderRepository orderRepository,
  }) : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, BusinessOrderEntity>> call(
    UpdatePaymentStatusUsecaseParams params,
  ) {
    return _orderRepository.updatePaymentStatus(
      orderId: params.orderId,
      paymentStatus: params.paymentStatus,
      token: params.token,
    );
  }
}
