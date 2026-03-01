import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/users/payment/domain/entity/user_payment_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IUserPaymentRepository {
  Future<Either<Failure, InitiatePaymentEntity>> initiateKhaltiPayment({
    required String token,
    required String orderId,
    required double amount,
    required String returnUrl,
  });

  Future<Either<Failure, UserPaymentEntity>> verifyKhaltiPayment({
    required String token,
    required String pidx,
    required String orderId,
  });

  Future<Either<Failure, UserPaymentEntity>> getPaymentByOrderId({
    required String token,
    required String orderId,
  });

  Future<Either<Failure, List<UserPaymentEntity>>> getUserPayments({
    required String token,
    int page,
    int limit,
    String? status,
  });
}
