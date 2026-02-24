import 'package:agrix/features/business/buisness_dashboard/product/domain/entity/business_product_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/product/domain/usecase/business_product_usecase.dart';
import 'package:agrix/features/business/buisness_dashboard/product/presentation/state/business_product_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productViewModelProvider =
    NotifierProvider<ProductViewModel, ProductState>(() => ProductViewModel());

class ProductViewModel extends Notifier<ProductState> {
  late AddProductUsecase _addProductUsecase;
  late GetBusinessProductsUsecase _getBusinessProductsUsecase;
  late DeleteProductUsecase _deleteProductUsecase;
  UpdateProductUsecase? _updateProductUsecase;

  @override
  ProductState build() {
    _addProductUsecase = ref.read(addProductUsecaseProvider);
    _getBusinessProductsUsecase = ref.read(getBusinessProductsUsecaseProvider);
    _deleteProductUsecase = ref.read(deleteProductUsecaseProvider);
    return ProductState();
  }

  Future<void> addProduct({
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
    state = state.copyWith(status: ProductStatus.adding);

    final params = AddProductUsecaseParams(
      name: name,
      categoryId: categoryId,
      price: price,
      stock: stock,
      brand: brand,
      discount: discount,
      weight: weight,
      unitType: unitType,
      shortDescription: shortDescription,
      fullDescription: fullDescription,
      imagePath: imagePath,
      token: token,
    );

    final result = await _addProductUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductStatus.error,
          errorMessage: failure.message,
        );
      },
      (product) {
        final updatedProducts = List<ProductEntity>.from(state.products)
          ..add(product);
        state = state.copyWith(
          status: ProductStatus.added,
          products: updatedProducts,
        );
      },
    );
  }

  Future<void> getBusinessProducts({required String token}) async {
    state = state.copyWith(status: ProductStatus.loading);

    final params = GetBusinessProductsUsecaseParams(token: token);
    final result = await _getBusinessProductsUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductStatus.error,
          errorMessage: failure.message,
        );
      },
      (products) {
        state = state.copyWith(
          status: ProductStatus.loaded,
          products: products,
        );
      },
    );
  }

  Future<void> updateProduct({
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
    state = state.copyWith(status: ProductStatus.updating);

    try {
      _updateProductUsecase ??= ref.read(updateProductUsecaseProvider);

      if (_updateProductUsecase == null) {
        throw Exception("Failed to initialize update product usecase");
      }

      final params = UpdateProductUsecaseParams(
        productId: productId,
        name: name,
        categoryId: categoryId,
        price: price,
        stock: stock,
        brand: brand,
        discount: discount,
        weight: weight,
        unitType: unitType,
        shortDescription: shortDescription,
        fullDescription: fullDescription,
        imagePath: imagePath,
        token: token,
      );

      final result = await _updateProductUsecase!.call(params);

      result.fold(
        (failure) {
          state = state.copyWith(
            status: ProductStatus.error,
            errorMessage: failure.message,
          );
        },
        (product) {
          final updatedProducts =
              state.products.map((p) {
                return p.id == product.id ? product : p;
              }).toList();

          state = state.copyWith(
            status: ProductStatus.updated,
            products: updatedProducts,
            selectedProduct: product,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: ProductStatus.error,
        errorMessage: "Failed to update product: $e",
      );
    }
  }

  Future<void> deleteProduct({
    required String productId,
    required String token,
  }) async {
    state = state.copyWith(status: ProductStatus.deleting);

    final params = DeleteProductUsecaseParams(
      productId: productId,
      token: token,
    );

    final result = await _deleteProductUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductStatus.error,
          errorMessage: failure.message,
        );
      },
      (isDeleted) {
        if (isDeleted) {
          final updatedProducts =
              state.products
                  .where((product) => product.id != productId)
                  .toList();
          state = state.copyWith(
            status: ProductStatus.deleted,
            products: updatedProducts,
          );
        }
      },
    );
  }

  void selectProduct(ProductEntity product) {
    state = state.copyWith(selectedProduct: product);
  }

  void clearSelection() {
    state = state.copyWith(selectedProduct: null);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = ProductState();
  }
}
