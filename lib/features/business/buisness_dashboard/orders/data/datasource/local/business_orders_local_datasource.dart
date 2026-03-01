import 'package:agrix/core/services/hive/hive_service.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/data/datasource/business_order_datasource.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/data/model/business_order_hive_model.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/data/model/business_order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessOrderLocalDatasourceProvider =
    Provider<IBusinessOrderLocalDatasource>((ref) {
      final hiveService = ref.read(hiveServiceProvider);
      return BusinessOrderLocalDatasource(hiveService: hiveService);
    });

class BusinessOrderLocalDatasource implements IBusinessOrderLocalDatasource {
  final HiveService _hiveService;

  BusinessOrderLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> addOrder(BusinessOrderHiveModel model) async {
    try {
      await _hiveService.addBusinessOrder(model);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<BusinessOrderHiveModel>> getBusinessOrders(
    String businessId,
  ) async {
    try {
      return _hiveService.getBusinessOrders(businessId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<BusinessOrderHiveModel?> getOrderById(String orderId) async {
    try {
      return _hiveService.getBusinessOrderById(orderId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateOrder(BusinessOrderHiveModel model) async {
    try {
      await _hiveService.updateBusinessOrder(model);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteOrder(String orderId) async {
    try {
      await _hiveService.deleteBusinessOrder(orderId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> syncOrders(
    String businessId,
    List<BusinessOrderApiModel> apiOrders,
  ) async {
    try {
      // Convert API models to Hive models
      final hiveModels =
          apiOrders.map((apiModel) {
            return BusinessOrderHiveModel.fromEntity(apiModel.toEntity());
          }).toList();

      // Clear existing orders for this business and add new ones
      await _hiveService.clearBusinessOrders(businessId);
      for (final model in hiveModels) {
        await _hiveService.addBusinessOrder(model);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> clearBusinessOrders(String businessId) async {
    try {
      await _hiveService.clearBusinessOrders(businessId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
