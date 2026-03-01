import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/usecases/app_usecases.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/repositories/business_product_repository.dart';
import 'package:agrix/features/business/buisness_dashboard/product/domain/entity/business_product_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/product/domain/repository/business_product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Add Product Usecase
class AddProductUsecaseParams extends Equatable {
  final String name;
  final String categoryId;
  final double price;
  final int stock;
  final String? brand;
  final double? discount;
  final double? weight;
  final String? unitType;
  final String? shortDescription;
  final String? fullDescription;
  final String? imagePath;
  final String token;

  const AddProductUsecaseParams({
    required this.name,
    required this.categoryId,
    required this.price,
    required this.stock,
    this.brand,
    this.discount,
    this.weight,
    this.unitType,
    this.shortDescription,
    this.fullDescription,
    this.imagePath,
    required this.token,
  });

  @override
  List<Object?> get props => [
    name,
    categoryId,
    price,
    stock,
    brand,
    discount,
    weight,
    unitType,
    shortDescription,
    fullDescription,
    imagePath,
    token,
  ];
}

final addProductUsecaseProvider = Provider<AddProductUsecase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return AddProductUsecase(productRepository: productRepository);
});

class AddProductUsecase
    implements UsecaseWithParams<ProductEntity, AddProductUsecaseParams> {
  final IProductRepository _productRepository;

  AddProductUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, ProductEntity>> call(AddProductUsecaseParams params) {
    return _productRepository.addProduct(
      name: params.name,
      categoryId: params.categoryId,
      price: params.price,
      stock: params.stock,
      brand: params.brand,
      discount: params.discount,
      weight: params.weight,
      unitType: params.unitType,
      shortDescription: params.shortDescription,
      fullDescription: params.fullDescription,
      imagePath: params.imagePath,
      token: params.token,
    );
  }
}

// Get Business Products Usecase
class GetBusinessProductsUsecaseParams extends Equatable {
  final String token;

  const GetBusinessProductsUsecaseParams({required this.token});

  @override
  List<Object?> get props => [token];
}

final getBusinessProductsUsecaseProvider = Provider<GetBusinessProductsUsecase>(
  (ref) {
    final productRepository = ref.read(productRepositoryProvider);
    return GetBusinessProductsUsecase(productRepository: productRepository);
  },
);

class GetBusinessProductsUsecase
    implements
        UsecaseWithParams<
          List<ProductEntity>,
          GetBusinessProductsUsecaseParams
        > {
  final IProductRepository _productRepository;

  GetBusinessProductsUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    GetBusinessProductsUsecaseParams params,
  ) {
    return _productRepository.getBusinessProducts(token: params.token);
  }
}

// Delete Product Usecase
class DeleteProductUsecaseParams extends Equatable {
  final String productId;
  final String token;

  const DeleteProductUsecaseParams({
    required this.productId,
    required this.token,
  });

  @override
  List<Object?> get props => [productId, token];
}

final deleteProductUsecaseProvider = Provider<DeleteProductUsecase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return DeleteProductUsecase(productRepository: productRepository);
});

class DeleteProductUsecase
    implements UsecaseWithParams<bool, DeleteProductUsecaseParams> {
  final IProductRepository _productRepository;

  DeleteProductUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteProductUsecaseParams params) {
    return _productRepository.deleteProduct(
      productId: params.productId,
      token: params.token,
    );
  }
}
