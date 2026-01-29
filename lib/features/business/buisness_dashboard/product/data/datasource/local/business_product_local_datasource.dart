import 'package:agrix/core/services/hive/hive_service.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/datasource/business_product_datasource.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/model/business_product_api_model.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/model/business_product_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessProductLocalDatasourceProvider =
    Provider<IProductLocalDatasource>((ref) {
      final hiveService = ref.read(hiveServiceProvider);
      return BusinessProductLocalDatasource(hiveService: hiveService);
    });

class BusinessProductLocalDatasource implements IProductLocalDatasource {
  final HiveService _hiveService;

  BusinessProductLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> addProduct(ProductHiveModel model) async {
    try {
      await _hiveService.addProduct(model);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ProductHiveModel>> getBusinessProducts(String businessId) async {
    try {
      return _hiveService.getBusinessProducts(businessId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ProductHiveModel?> getProductById(String productId) async {
    try {
      return _hiveService.getProductById(productId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateProduct(ProductHiveModel model) async {
    try {
      await _hiveService.updateProduct(model);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteProduct(String productId) async {
    try {
      await _hiveService.deleteProduct(productId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> syncProducts(
    String businessId,
    List<ProductApiModel> apiProducts,
  ) async {
    try {
      // Convert API models to Hive models
      final hiveModels =
          apiProducts.map((apiModel) {
            return ProductHiveModel(
              productId: apiModel.id,
              businessId: businessId,
              name: apiModel.name,
              categoryId: apiModel.categoryId,
              categoryName: apiModel.categoryName,
              brand: apiModel.brand,
              price: apiModel.price,
              discount: apiModel.discount,
              stock: apiModel.stock,
              weight: apiModel.weight,
              unitType: apiModel.unitType,
              shortDescription: apiModel.shortDescription,
              fullDescription: apiModel.fullDescription,
              image: apiModel.image,
              createdAt: apiModel.createdAt,
              updatedAt: apiModel.updatedAt,
            );
          }).toList();

      // Clear existing products and add new ones
      await _hiveService.clearBusinessProducts(businessId);
      for (final model in hiveModels) {
        await _hiveService.addProduct(model);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
