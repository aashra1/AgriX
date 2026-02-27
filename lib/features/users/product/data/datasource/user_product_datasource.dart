import 'package:agrix/features/users/product/data/model/user_product_hive_model.dart';

abstract class IUserProductLocalDatasource {
  Future<bool> addProduct(UserProductHiveModel model);
  Future<List<UserProductHiveModel>> getAllProducts();
  Future<List<UserProductHiveModel>> getProductsByCategory(String categoryId);
  Future<UserProductHiveModel?> getProductById(String productId);
  Future<bool> updateProduct(UserProductHiveModel model);
  Future<bool> deleteProduct(String productId);
  Future<bool> syncProducts(List<UserProductHiveModel> apiProducts);
  Future<bool> clearAllProducts();
}

abstract interface class IUserProductRemoteDatasource {
  Future<List<UserProductHiveModel>> getAllProducts({int page, int limit});

  Future<List<UserProductHiveModel>> getProductsByCategory({
    required String categoryId,
    int page,
    int limit,
  });

  Future<UserProductHiveModel> getProductById({required String productId});

  Future<List<UserProductHiveModel>> searchProducts({
    required String query,
    int page,
    int limit,
  });
}
