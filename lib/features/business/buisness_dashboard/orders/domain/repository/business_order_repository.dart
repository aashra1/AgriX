import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/domain/entity/business_order_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IBusinessOrderRepository {
  Future<Either<Failure, List<BusinessOrderEntity>>> getBusinessOrders({
    required String token,
    required String businessId,
    int page,
    int limit,
  });

  Future<Either<Failure, BusinessOrderEntity>> getOrderById({
    required String orderId,
    required String token,
  });

  Future<Either<Failure, BusinessOrderEntity>> updateOrderStatus({
    required String orderId,
    required String orderStatus,
    String? trackingNumber,
    required String token,
  });

  Future<Either<Failure, BusinessOrderEntity>> updatePaymentStatus({
    required String orderId,
    required String paymentStatus,
    required String token,
  });
}
