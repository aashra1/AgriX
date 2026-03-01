import 'package:agrix/features/business/buisness_dashboard/orders/data/model/business_order_hive_model.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/data/model/business_order_model.dart';

abstract class IBusinessOrderLocalDatasource {
  Future<bool> addOrder(BusinessOrderHiveModel model);
  Future<List<BusinessOrderHiveModel>> getBusinessOrders(String businessId);
  Future<BusinessOrderHiveModel?> getOrderById(String orderId);
  Future<bool> updateOrder(BusinessOrderHiveModel model);
  Future<bool> deleteOrder(String orderId);
  Future<bool> syncOrders(
    String businessId,
    List<BusinessOrderApiModel> apiOrders,
  );
  Future<bool> clearBusinessOrders(String businessId);
}

abstract interface class IBusinessOrderRemoteDatasource {
  Future<List<BusinessOrderApiModel>> getBusinessOrders({
    required String token,
    int page,
    int limit,
  });

  Future<BusinessOrderApiModel> getOrderById({
    required String orderId,
    required String token,
  });

  Future<BusinessOrderApiModel> updateOrderStatus({
    required String orderId,
    required String orderStatus,
    String? trackingNumber,
    required String token,
  });

  Future<BusinessOrderApiModel> updatePaymentStatus({
    required String orderId,
    required String paymentStatus,
    required String token,
  });
}
