import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/users/product/domain/entity/user_product_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IUserProductRepository {
  Future<Either<Failure, List<UserProductEntity>>> getAllProducts({
    int page,
    int limit,
    bool refresh,
  });

  Future<Either<Failure, List<UserProductEntity>>> getProductsByCategory({
    required String categoryId,
    int page,
    int limit,
    bool refresh,
  });

  Future<Either<Failure, UserProductEntity>> getProductById({
    required String productId,
  });

  Future<Either<Failure, List<UserProductEntity>>> searchProducts({
    required String query,
    int page,
    int limit,
  });

  Future<Either<Failure, void>> clearLocalProducts();
}
