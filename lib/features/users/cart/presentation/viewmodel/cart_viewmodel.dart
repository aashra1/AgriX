import 'package:agrix/features/users/cart/domain/usecase/cart_usecase.dart';
import 'package:agrix/features/users/cart/presentation/state/cart_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartViewModelProvider = NotifierProvider<CartViewModel, CartState>(
  () => CartViewModel(),
);

class CartViewModel extends Notifier<CartState> {
  late GetCartUsecase _getCartUsecase;
  late AddToCartUsecase _addToCartUsecase;
  late UpdateCartItemUsecase _updateCartItemUsecase;
  late RemoveFromCartUsecase _removeFromCartUsecase;
  late ClearCartUsecase _clearCartUsecase;
  late GetCartCountUsecase _getCartCountUsecase;

  @override
  CartState build() {
    _getCartUsecase = ref.read(getCartUsecaseProvider);
    _addToCartUsecase = ref.read(addToCartUsecaseProvider);
    _updateCartItemUsecase = ref.read(updateCartItemUsecaseProvider);
    _removeFromCartUsecase = ref.read(removeFromCartUsecaseProvider);
    _clearCartUsecase = ref.read(clearCartUsecaseProvider);
    _getCartCountUsecase = ref.read(getCartCountUsecaseProvider);
    return const CartState();
  }

  Future<void> getCart({required String token}) async {
    state = state.copyWith(status: CartStatus.loading);

    final params = GetCartUsecaseParams(token: token);
    final result = await _getCartUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CartStatus.error,
          errorMessage: failure.message,
        );
      },
      (cart) {
        state = state.copyWith(
          status: CartStatus.loaded,
          cart: cart,
          itemCount: cart.totalItems,
        );
      },
    );
  }

  Future<void> addToCart({
    required String token,
    required String productId,
    required int quantity,
  }) async {
    state = state.copyWith(status: CartStatus.updating, isUpdating: true);

    final params = AddToCartUsecaseParams(
      token: token,
      productId: productId,
      quantity: quantity,
    );

    final result = await _addToCartUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CartStatus.error,
          errorMessage: failure.message,
          isUpdating: false,
        );
      },
      (cart) {
        state = state.copyWith(
          status: CartStatus.updated,
          cart: cart,
          itemCount: cart.totalItems,
          isUpdating: false,
        );
      },
    );
  }

  Future<void> updateCartItem({
    required String token,
    required String productId,
    required int quantity,
  }) async {
    state = state.copyWith(status: CartStatus.updating, isUpdating: true);

    final params = UpdateCartItemUsecaseParams(
      token: token,
      productId: productId,
      quantity: quantity,
    );

    final result = await _updateCartItemUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CartStatus.error,
          errorMessage: failure.message,
          isUpdating: false,
        );
      },
      (cart) {
        state = state.copyWith(
          status: CartStatus.updated,
          cart: cart,
          itemCount: cart.totalItems,
          isUpdating: false,
        );
      },
    );
  }

  Future<void> removeFromCart({
    required String token,
    required String productId,
  }) async {
    state = state.copyWith(status: CartStatus.updating, isUpdating: true);

    final params = RemoveFromCartUsecaseParams(
      token: token,
      productId: productId,
    );

    final result = await _removeFromCartUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CartStatus.error,
          errorMessage: failure.message,
          isUpdating: false,
        );
      },
      (cart) {
        state = state.copyWith(
          status: CartStatus.updated,
          cart: cart,
          itemCount: cart.totalItems,
          isUpdating: false,
        );
      },
    );
  }

  Future<void> clearCart({required String token}) async {
    state = state.copyWith(status: CartStatus.updating, isUpdating: true);

    final params = ClearCartUsecaseParams(token: token);
    final result = await _clearCartUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CartStatus.error,
          errorMessage: failure.message,
          isUpdating: false,
        );
      },
      (cart) {
        state = state.copyWith(
          status: CartStatus.updated,
          cart: cart,
          itemCount: cart.totalItems,
          isUpdating: false,
        );
      },
    );
  }

  Future<int> getCartCount({required String token}) async {
    final params = GetCartCountUsecaseParams(token: token);
    final result = await _getCartCountUsecase.call(params);

    return result.fold((failure) => 0, (count) => count);
  }

  void resetStatus() {
    if (state.status == CartStatus.updated) {
      state = state.copyWith(status: CartStatus.loaded);
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = const CartState();
  }
}
