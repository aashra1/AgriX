import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/services/connectivity/network_infor.dart';
import 'package:agrix/features/users/product/data/datasource/local/user_product_local_datasource.dart';
import 'package:agrix/features/users/product/data/datasource/remote/user_product_remote_datasource.dart';
import 'package:agrix/features/users/product/data/datasource/user_product_datasource.dart';
import 'package:agrix/features/users/product/data/model/user_product_hive_model.dart';
import 'package:agrix/features/users/product/domain/entity/user_product_entity.dart';
import 'package:agrix/features/users/product/domain/repository/user_product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProductRepositoryProvider = Provider<IUserProductRepository>((ref) {
  final localDatasource = ref.read(userProductLocalDatasourceProvider);
  final remoteDatasource = ref.read(userProductRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return UserProductRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class UserProductRepository implements IUserProductRepository {
  final IUserProductLocalDatasource _localDatasource;
  final IUserProductRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  UserProductRepository({
    required IUserProductLocalDatasource localDatasource,
    required IUserProductRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _localDatasource = localDatasource,
       _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<UserProductEntity>>> getAllProducts({
    int page = 1,
    int limit = 20,
    bool refresh = false,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected == true) {
        final apiProducts = await _remoteDatasource.getAllProducts(
          page: page,
          limit: limit,
        );

        if (refresh || page == 1) {
          await _localDatasource.syncProducts(apiProducts);
        } else {
          for (final product in apiProducts) {
            await _localDatasource.addProduct(product);
          }
        }

        final entities = UserProductHiveModel.toEntityList(apiProducts);
        return Right(entities);
      } else {
        final localProducts = await _localDatasource.getAllProducts();
        final entities = UserProductHiveModel.toEntityList(localProducts);
        return Right(entities);
      }
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
  }

  @override
  Future<Either<Failure, List<UserProductEntity>>> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
    bool refresh = false,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected == true) {
        final apiProducts = await _remoteDatasource.getProductsByCategory(
          categoryId: categoryId,
          page: page,
          limit: limit,
        );

        final entities = UserProductHiveModel.toEntityList(apiProducts);
        return Right(entities);
      } else {
        final localProducts = await _localDatasource.getProductsByCategory(
          categoryId,
        );
        final entities = UserProductHiveModel.toEntityList(localProducts);
        return Right(entities);
      }
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
  }

  @override
  Future<Either<Failure, UserProductEntity>> getProductById({
    required String productId,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected == true) {
        final apiProduct = await _remoteDatasource.getProductById(
          productId: productId,
        );

        await _localDatasource.addProduct(apiProduct);

        return Right(apiProduct.toEntity());
      } else {
        final localProduct = await _localDatasource.getProductById(productId);
        if (localProduct != null) {
          return Right(localProduct.toEntity());
        }
        return Left(LocalDatabaseFailure(message: 'Product not found locally'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return Left(ApiFailure(message: 'Product not found', statusCode: 404));
      }
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch product',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserProductEntity>>> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected == true) {
        final apiProducts = await _remoteDatasource.searchProducts(
          query: query,
          page: page,
          limit: limit,
        );

        final entities = UserProductHiveModel.toEntityList(apiProducts);
        return Right(entities);
      } else {
        final allProducts = await _localDatasource.getAllProducts();
        final filtered =
            allProducts
                .where(
                  (product) =>
                      product.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
        final entities = UserProductHiveModel.toEntityList(filtered);
        return Right(entities);
      }
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to search products',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearLocalProducts() async {
    try {
      await _localDatasource.clearAllProducts();
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
