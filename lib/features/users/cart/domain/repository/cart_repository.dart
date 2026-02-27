import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/users/cart/domain/entity/cart_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ICartRepository {
  Future<Either<Failure, CartEntity>> getCart({required String token});

  Future<Either<Failure, CartEntity>> addToCart({
    required String token,
    required String productId,
    required int quantity,
  });

  Future<Either<Failure, CartEntity>> updateCartItem({
    required String token,
    required String productId,
    required int quantity,
  });

  Future<Either<Failure, CartEntity>> removeFromCart({
    required String token,
    required String productId,
  });

  Future<Either<Failure, CartEntity>> clearCart({required String token});

  Future<Either<Failure, int>> getCartCount({required String token});
}
