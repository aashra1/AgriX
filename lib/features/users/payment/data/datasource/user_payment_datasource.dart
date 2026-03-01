import 'package:agrix/features/users/payment/data/model/user_payment_model.dart';

abstract interface class IUserPaymentRemoteDatasource {
  Future<InitiatePaymentApiModel> initiateKhaltiPayment({
    required String token,
    required String orderId,
    required double amount,
    required String returnUrl,
  });

  Future<UserPaymentApiModel> verifyKhaltiPayment({
    required String token,
    required String pidx,
    required String orderId,
  });

  Future<UserPaymentApiModel> getPaymentByOrderId({
    required String token,
    required String orderId,
  });

  Future<List<UserPaymentApiModel>> getUserPayments({
    required String token,
    int page,
    int limit,
    String? status,
  });
}
