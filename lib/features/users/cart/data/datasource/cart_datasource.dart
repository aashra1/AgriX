import 'package:agrix/features/users/cart/data/model/cart_model.dart';

abstract interface class ICartRemoteDatasource {
  Future<CartApiModel> getCart({required String token});
  Future<CartApiModel> addToCart({
    required String token,
    required String productId,
    required int quantity,
  });
  Future<CartApiModel> updateCartItem({
    required String token,
    required String productId,
    required int quantity,
  });
  Future<CartApiModel> removeFromCart({
    required String token,
    required String productId,
  });
  Future<CartApiModel> clearCart({required String token});
  Future<int> getCartCount({required String token});
}
