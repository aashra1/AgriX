import 'package:agrix/features/business/buisness_dashboard/product/data/model/business_product_api_model.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/model/business_product_hive_model.dart';

abstract class IProductLocalDatasource {
  Future<bool> addProduct(ProductHiveModel model);
  Future<List<ProductHiveModel>> getBusinessProducts(String businessId);
  Future<ProductHiveModel?> getProductById(String productId);
  Future<bool> updateProduct(ProductHiveModel model);
  Future<bool> deleteProduct(String productId);
  Future<bool> syncProducts(
    String businessId,
    List<ProductApiModel> apiProducts,
  );
}

abstract interface class IProductRemoteDatasource {
  Future<ProductApiModel> addProduct({
    required Map<String, dynamic> productData,
    required String token,
    String? imagePath,
  });
  Future<List<ProductApiModel>> getBusinessProducts(String token);
  Future<ProductApiModel> getProductById({
    required String productId,
    required String token,
  });
  Future<ProductApiModel> updateProduct({
    required String productId,
    required Map<String, dynamic> productData,
    required String token,
    String? imagePath,
  });
  Future<bool> deleteProduct({
    required String productId,
    required String token,
  });
}
