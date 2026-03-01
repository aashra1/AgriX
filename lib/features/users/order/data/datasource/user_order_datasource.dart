import 'package:agrix/features/users/order/data/model/user_order_api_model.dart';
import 'package:agrix/features/users/order/data/model/user_order_hive_model.dart';

abstract class IUserOrderLocalDatasource {
  Future<bool> addOrder(UserOrderHiveModel order);
  Future<List<UserOrderHiveModel>> getUserOrders(String userId);
  Future<UserOrderHiveModel?> getOrderById(String orderId);
  Future<bool> updateOrder(UserOrderHiveModel order);
  Future<bool> deleteOrder(String orderId);
  Future<bool> syncOrders(String userId, List<UserOrderApiModel> apiOrders);
  Future<bool> clearUserOrders(String userId);
}

abstract interface class IUserOrderRemoteDatasource {
  Future<UserOrderApiModel> createOrder({
    required String token,
    required Map<String, dynamic> orderData,
  });

  Future<List<UserOrderApiModel>> getUserOrders({
    required String token,
    int page,
    int limit,
  });

  Future<UserOrderApiModel> getOrderById({
    required String token,
    required String orderId,
  });
}
