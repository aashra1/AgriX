import 'package:agrix/features/users/product/domain/entity/user_product_entity.dart';
import 'package:agrix/features/users/product/domain/usecase/user_product_usecase.dart';
import 'package:agrix/features/users/product/presentation/state/user_product_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProductViewModelProvider =
    NotifierProvider<UserProductViewModel, UserProductState>(
      () => UserProductViewModel(),
    );

class UserProductViewModel extends Notifier<UserProductState> {
  late GetAllUserProductsUsecase _getAllProductsUsecase;
  late GetUserProductsByCategoryUsecase _getProductsByCategoryUsecase;
  late GetUserProductByIdUsecase _getProductByIdUsecase;
  late SearchUserProductsUsecase _searchProductsUsecase;

  @override
  UserProductState build() {
    _getAllProductsUsecase = ref.read(getAllUserProductsUsecaseProvider);
    _getProductsByCategoryUsecase = ref.read(
      getUserProductsByCategoryUsecaseProvider,
    );
    _getProductByIdUsecase = ref.read(getUserProductByIdUsecaseProvider);
    _searchProductsUsecase = ref.read(searchUserProductsUsecaseProvider);
    return const UserProductState();
  }

  Future<void> getAllProducts({
    int page = 1,
    int limit = 20,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = state.copyWith(status: UserProductStatus.loading, products: []);
    } else if (state.hasReachedMax ||
        state.status == UserProductStatus.loading) {
      return;
    }

    state = state.copyWith(status: UserProductStatus.loading);

    final params = GetAllUserProductsUsecaseParams(
      page: page,
      limit: limit,
      refresh: refresh,
    );

    final result = await _getAllProductsUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserProductStatus.error,
          errorMessage: failure.message,
        );
      },
      (products) {
        final updatedProducts =
            refresh || page == 1 ? products : [...state.products, ...products];

        state = state.copyWith(
          status: UserProductStatus.loaded,
          products: updatedProducts,
          currentPage: page,
          hasReachedMax: products.length < limit,
        );
      },
    );
  }

  Future<void> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int limit = 20,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = state.copyWith(status: UserProductStatus.loading, products: []);
    }

    state = state.copyWith(status: UserProductStatus.loading);

    final params = GetUserProductsByCategoryUsecaseParams(
      categoryId: categoryId,
      page: page,
      limit: limit,
      refresh: refresh,
    );

    final result = await _getProductsByCategoryUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserProductStatus.error,
          errorMessage: failure.message,
        );
      },
      (products) {
        state = state.copyWith(
          status: UserProductStatus.loaded,
          products: products,
          currentPage: page,
          hasReachedMax: products.length < limit,
        );
      },
    );
  }

  Future<void> getProductById({required String productId}) async {
    state = state.copyWith(status: UserProductStatus.loading);

    final params = GetUserProductByIdUsecaseParams(productId: productId);

    final result = await _getProductByIdUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserProductStatus.error,
          errorMessage: failure.message,
        );
      },
      (product) {
        state = state.copyWith(
          status: UserProductStatus.loaded,
          selectedProduct: product,
        );
      },
    );
  }

  Future<void> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    state = state.copyWith(status: UserProductStatus.loading);

    final params = SearchUserProductsUsecaseParams(
      query: query,
      page: page,
      limit: limit,
    );

    final result = await _searchProductsUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserProductStatus.error,
          errorMessage: failure.message,
        );
      },
      (products) {
        state = state.copyWith(
          status: UserProductStatus.loaded,
          products: products,
          currentPage: page,
          hasReachedMax: products.length < limit,
        );
      },
    );
  }

  void selectProduct(UserProductEntity product) {
    state = state.copyWith(selectedProduct: product);
  }

  void clearSelection() {
    state = state.copyWith(selectedProduct: null);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = const UserProductState();
  }
}
