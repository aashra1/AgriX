import 'package:agrix/core/services/hive/hive_service.dart';
import 'package:agrix/features/users/order/data/datasource/user_order_datasource.dart';
import 'package:agrix/features/users/order/data/model/user_order_api_model.dart';
import 'package:agrix/features/users/order/data/model/user_order_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userOrderLocalDatasourceProvider = Provider<IUserOrderLocalDatasource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  return UserOrderLocalDatasource(hiveService: hiveService);
});

class UserOrderLocalDatasource implements IUserOrderLocalDatasource {
  final HiveService _hiveService;

  UserOrderLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> addOrder(UserOrderHiveModel order) async {
    try {
      await _hiveService.addUserOrder(order);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<UserOrderHiveModel>> getUserOrders(String userId) async {
    try {
      return _hiveService.getUserOrders(userId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<UserOrderHiveModel?> getOrderById(String orderId) async {
    try {
      return _hiveService.getUserOrderById(orderId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateOrder(UserOrderHiveModel order) async {
    try {
      await _hiveService.updateUserOrder(order);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteOrder(String orderId) async {
    try {
      await _hiveService.deleteUserOrder(orderId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> syncOrders(
    String userId,
    List<UserOrderApiModel> apiOrders,
  ) async {
    try {
      final hiveModels =
          apiOrders.map((apiModel) {
            return UserOrderHiveModel.fromEntity(apiModel.toEntity());
          }).toList();

      await _hiveService.clearUserOrders(userId);
      for (final model in hiveModels) {
        await _hiveService.addUserOrder(model);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> clearUserOrders(String userId) async {
    try {
      await _hiveService.clearUserOrders(userId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
