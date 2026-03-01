import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IUserOrderRepository {
  Future<Either<Failure, UserOrderEntity>> createOrder({
    required String token,
    required Map<String, dynamic> orderData,
  });

  Future<Either<Failure, List<UserOrderEntity>>> getUserOrders({
    required String token,
    int page,
    int limit,
    bool refresh,
  });

  Future<Either<Failure, UserOrderEntity>> getOrderById({
    required String token,
    required String orderId,
  });
}
