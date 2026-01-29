import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/business/buisness_dashboard/product/domain/entity/business_product_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IProductRepository {
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
  });

  Future<Either<Failure, List<ProductEntity>>> getBusinessProducts({
    required String token,
  });

  Future<Either<Failure, ProductEntity>> getProductById({
    required String productId,
    required String token,
  });

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
  });

  Future<Either<Failure, bool>> deleteProduct({
    required String productId,
    required String token,
  });
}
