import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/services/connectivity/network_infor.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/datasource/business_product_datasource.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/datasource/local/business_product_local_datasource.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/datasource/remote/business_product_remote_Datasource.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/model/business_product_api_model.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/model/business_product_hive_model.dart';
import 'package:agrix/features/business/buisness_dashboard/product/domain/entity/business_product_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/product/domain/repository/business_product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRepositoryProvider = Provider<IProductRepository>((ref) {
  final localDatasource = ref.read(businessProductLocalDatasourceProvider);
  final remoteDatasource = ref.read(businessProductRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ProductRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class ProductRepository implements IProductRepository {
  final IProductLocalDatasource _localDatasource;
  final IProductRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  ProductRepository({
    required IProductLocalDatasource localDatasource,
    required IProductRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _localDatasource = localDatasource,
       _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, ProductEntity>> addProduct({
    required String name,
    required String categoryId,
    required double price,
    required int stock,
    String? brand,
    double? discount,
    double? weight,
    String? unitType,
    String? shortDescription,
    String? fullDescription,
    String? imagePath,
    required String token,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        // Prepare product data for API
        final productData = {
          'name': name,
          'category': categoryId,
          'price': price,
          'stock': stock,
          if (brand != null && brand.isNotEmpty) 'brand': brand,
          if (discount != null && discount > 0) 'discount': discount,
          if (weight != null && weight > 0) 'weight': weight,
          if (unitType != null && unitType.isNotEmpty) 'unitType': unitType,
          if (shortDescription != null && shortDescription.isNotEmpty)
            'shortDescription': shortDescription,
          if (fullDescription != null && fullDescription.isNotEmpty)
            'fullDescription': fullDescription,
        };

        // Call remote API
        final apiModel = await _remoteDatasource.addProduct(
          productData: productData,
          token: token,
          imagePath: imagePath,
        );

        // Save to local storage
        final hiveModel = ProductHiveModel.fromEntity(
          apiModel.toProductEntity(),
        );
        await _localDatasource.addProduct(hiveModel);

        return Right(apiModel.toProductEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to add product',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        // Create local product for offline mode
        final localProduct = ProductHiveModel(
          businessId: '', // Will be set when syncing
          name: name,
          categoryId: categoryId,
          brand: brand,
          price: price,
          discount: discount ?? 0.0,
          stock: stock,
          weight: weight,
          unitType: unitType,
          shortDescription: shortDescription,
          fullDescription: fullDescription,
          image: imagePath,
        );

        await _localDatasource.addProduct(localProduct);
        return Right(localProduct.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getBusinessProducts({
    required String token,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiProducts = await _remoteDatasource.getBusinessProducts(token);

        // Get business ID from first product or storage
        final businessId =
            apiProducts.isNotEmpty ? apiProducts.first.businessId : '';

        // Sync to local storage
        if (businessId.isNotEmpty) {
          await _localDatasource.syncProducts(businessId, apiProducts);
        }

        final entities = ProductApiModel.toProductEntityList(apiProducts);
        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to fetch products',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        // Get business ID from local storage (you need to implement this)
        final businessId = ''; // Get from UserSessionService

        final localProducts = await _localDatasource.getBusinessProducts(
          businessId,
        );
        final entities = ProductHiveModel.toEntityList(localProducts);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById({
    required String productId,
    required String token,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _remoteDatasource.getProductById(
          productId: productId,
          token: token,
        );

        // Update local storage
        final hiveModel = ProductHiveModel.fromEntity(
          apiModel.toProductEntity(),
        );
        await _localDatasource.updateProduct(hiveModel);

        return Right(apiModel.toProductEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to fetch product',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final localProduct = await _localDatasource.getProductById(productId);
        if (localProduct != null) {
          return Right(localProduct.toEntity());
        }
        return Left(LocalDatabaseFailure(message: 'Product not found locally'));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> updateProduct({
    required String productId,
    String? name,
    String? categoryId,
    double? price,
    int? stock,
    String? brand,
    double? discount,
    double? weight,
    String? unitType,
    String? shortDescription,
    String? fullDescription,
    String? imagePath,
    required String token,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        // Prepare update data
        final updateData = <String, dynamic>{};
        if (name != null) updateData['name'] = name;
        if (categoryId != null) updateData['category'] = categoryId;
        if (price != null) updateData['price'] = price;
        if (stock != null) updateData['stock'] = stock;
        if (brand != null) updateData['brand'] = brand;
        if (discount != null) updateData['discount'] = discount;
        if (weight != null) updateData['weight'] = weight;
        if (unitType != null) updateData['unitType'] = unitType;
        if (shortDescription != null)
          updateData['shortDescription'] = shortDescription;
        if (fullDescription != null)
          updateData['fullDescription'] = fullDescription;

        final apiModel = await _remoteDatasource.updateProduct(
          productId: productId,
          productData: updateData,
          token: token,
          imagePath: imagePath,
        );

        // Update local storage
        final hiveModel = ProductHiveModel.fromEntity(
          apiModel.toProductEntity(),
        );
        await _localDatasource.updateProduct(hiveModel);

        return Right(apiModel.toProductEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to update product',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        // Get existing product
        final existingProduct = await _localDatasource.getProductById(
          productId,
        );
        if (existingProduct == null) {
          return Left(LocalDatabaseFailure(message: 'Product not found'));
        }

        // Create updated model
        final updatedModel = ProductHiveModel(
          productId: productId,
          businessId: existingProduct.businessId,
          name: name ?? existingProduct.name,
          categoryId: categoryId ?? existingProduct.categoryId,
          categoryName: existingProduct.categoryName,
          brand: brand ?? existingProduct.brand,
          price: price ?? existingProduct.price,
          discount: discount ?? existingProduct.discount,
          stock: stock ?? existingProduct.stock,
          weight: weight ?? existingProduct.weight,
          unitType: unitType ?? existingProduct.unitType,
          shortDescription:
              shortDescription ?? existingProduct.shortDescription,
          fullDescription: fullDescription ?? existingProduct.fullDescription,
          image: imagePath ?? existingProduct.image,
          createdAt: existingProduct.createdAt,
          updatedAt: DateTime.now(),
        );

        await _localDatasource.updateProduct(updatedModel);
        return Right(updatedModel.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct({
    required String productId,
    required String token,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final isDeleted = await _remoteDatasource.deleteProduct(
          productId: productId,
          token: token,
        );

        if (isDeleted) {
          await _localDatasource.deleteProduct(productId);
        }

        return Right(isDeleted);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to delete product',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        await _localDatasource.deleteProduct(productId);
        return Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
