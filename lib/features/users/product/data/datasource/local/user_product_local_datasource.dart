import 'package:agrix/core/services/hive/hive_service.dart';
import 'package:agrix/features/users/product/data/datasource/user_product_datasource.dart';
import 'package:agrix/features/users/product/data/model/user_product_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProductLocalDatasourceProvider =
    Provider<IUserProductLocalDatasource>((ref) {
      final hiveService = ref.read(hiveServiceProvider);
      return UserProductLocalDatasource(hiveService: hiveService);
    });

class UserProductLocalDatasource implements IUserProductLocalDatasource {
  final HiveService _hiveService;

  UserProductLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> addProduct(UserProductHiveModel model) async {
    try {
      await _hiveService.addUserProduct(model);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<UserProductHiveModel>> getAllProducts() async {
    try {
      return _hiveService.getAllUserProducts();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<UserProductHiveModel>> getProductsByCategory(
    String categoryId,
  ) async {
    try {
      return _hiveService.getUserProductsByCategory(categoryId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<UserProductHiveModel?> getProductById(String productId) async {
    try {
      return _hiveService.getUserProductById(productId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateProduct(UserProductHiveModel model) async {
    try {
      await _hiveService.updateUserProduct(model);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteProduct(String productId) async {
    try {
      await _hiveService.deleteUserProduct(productId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> syncProducts(List<UserProductHiveModel> apiProducts) async {
    try {
      await _hiveService.clearAllUserProducts();
      for (final model in apiProducts) {
        await _hiveService.addUserProduct(model);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> clearAllProducts() async {
    try {
      await _hiveService.clearAllUserProducts();
      return true;
    } catch (e) {
      return false;
    }
  }
}
