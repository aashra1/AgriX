import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/usecases/app_usecases.dart';
import 'package:agrix/features/users/product/data/repositories/user_product_repository.dart';
import 'package:agrix/features/users/product/domain/entity/user_product_entity.dart';
import 'package:agrix/features/users/product/domain/repository/user_product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllUserProductsUsecaseProvider = Provider<GetAllUserProductsUsecase>((
  ref,
) {
  final repository = ref.read(userProductRepositoryProvider);
  return GetAllUserProductsUsecase(repository: repository);
});

final getUserProductsByCategoryUsecaseProvider =
    Provider<GetUserProductsByCategoryUsecase>((ref) {
      final repository = ref.read(userProductRepositoryProvider);
      return GetUserProductsByCategoryUsecase(repository: repository);
    });

final getUserProductByIdUsecaseProvider = Provider<GetUserProductByIdUsecase>((
  ref,
) {
  final repository = ref.read(userProductRepositoryProvider);
  return GetUserProductByIdUsecase(repository: repository);
});

final searchUserProductsUsecaseProvider = Provider<SearchUserProductsUsecase>((
  ref,
) {
  final repository = ref.read(userProductRepositoryProvider);
  return SearchUserProductsUsecase(repository: repository);
});

class GetAllUserProductsUsecaseParams extends Equatable {
  final int page;
  final int limit;
  final bool refresh;

  const GetAllUserProductsUsecaseParams({
    this.page = 1,
    this.limit = 20,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [page, limit, refresh];
}

class GetAllUserProductsUsecase
    implements
        UsecaseWithParams<
          List<UserProductEntity>,
          GetAllUserProductsUsecaseParams
        > {
  final IUserProductRepository _repository;

  GetAllUserProductsUsecase({required IUserProductRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<UserProductEntity>>> call(
    GetAllUserProductsUsecaseParams params,
  ) {
    return _repository.getAllProducts(
      page: params.page,
      limit: params.limit,
      refresh: params.refresh,
    );
  }
}

class GetUserProductsByCategoryUsecaseParams extends Equatable {
  final String categoryId;
  final int page;
  final int limit;
  final bool refresh;

  const GetUserProductsByCategoryUsecaseParams({
    required this.categoryId,
    this.page = 1,
    this.limit = 20,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [categoryId, page, limit, refresh];
}

class GetUserProductsByCategoryUsecase
    implements
        UsecaseWithParams<
          List<UserProductEntity>,
          GetUserProductsByCategoryUsecaseParams
        > {
  final IUserProductRepository _repository;

  GetUserProductsByCategoryUsecase({required IUserProductRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<UserProductEntity>>> call(
    GetUserProductsByCategoryUsecaseParams params,
  ) {
    return _repository.getProductsByCategory(
      categoryId: params.categoryId,
      page: params.page,
      limit: params.limit,
      refresh: params.refresh,
    );
  }
}

class GetUserProductByIdUsecaseParams extends Equatable {
  final String productId;

  const GetUserProductByIdUsecaseParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class GetUserProductByIdUsecase
    implements
        UsecaseWithParams<UserProductEntity, GetUserProductByIdUsecaseParams> {
  final IUserProductRepository _repository;

  GetUserProductByIdUsecase({required IUserProductRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, UserProductEntity>> call(
    GetUserProductByIdUsecaseParams params,
  ) {
    return _repository.getProductById(productId: params.productId);
  }
}

class SearchUserProductsUsecaseParams extends Equatable {
  final String query;
  final int page;
  final int limit;

  const SearchUserProductsUsecaseParams({
    required this.query,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [query, page, limit];
}

class SearchUserProductsUsecase
    implements
        UsecaseWithParams<
          List<UserProductEntity>,
          SearchUserProductsUsecaseParams
        > {
  final IUserProductRepository _repository;

  SearchUserProductsUsecase({required IUserProductRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<UserProductEntity>>> call(
    SearchUserProductsUsecaseParams params,
  ) {
    return _repository.searchProducts(
      query: params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}
