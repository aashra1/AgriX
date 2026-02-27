import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/users/cart/data/datasource/cart_datasource.dart';
import 'package:agrix/features/users/cart/data/datasource/remote/cart_remote_datasource.dart';
import 'package:agrix/features/users/cart/domain/entity/cart_entity.dart';
import 'package:agrix/features/users/cart/domain/repository/cart_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartRepositoryProvider = Provider<ICartRepository>((ref) {
  final remoteDatasource = ref.read(cartRemoteDatasourceProvider);
  return CartRepository(remoteDatasource: remoteDatasource);
});

class CartRepository implements ICartRepository {
  final ICartRemoteDatasource _remoteDatasource;

  CartRepository({required ICartRemoteDatasource remoteDatasource})
    : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, CartEntity>> getCart({required String token}) async {
    try {
      final apiCart = await _remoteDatasource.getCart(token: token);
      return Right(apiCart.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch cart',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> addToCart({
    required String token,
    required String productId,
    required int quantity,
  }) async {
    try {
      final apiCart = await _remoteDatasource.addToCart(
        token: token,
        productId: productId,
        quantity: quantity,
      );
      return Right(apiCart.toEntity());
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? 'Failed to add to cart';
      if (e.response?.statusCode == 400) {
        message = e.response?.data['message'] ?? 'Invalid request';
      }
      return Left(
        ApiFailure(message: message, statusCode: e.response?.statusCode),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> updateCartItem({
    required String token,
    required String productId,
    required int quantity,
  }) async {
    try {
      final apiCart = await _remoteDatasource.updateCartItem(
        token: token,
        productId: productId,
        quantity: quantity,
      );
      return Right(apiCart.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return Left(
          ApiFailure(message: 'Item not found in cart', statusCode: 404),
        );
      }
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to update cart',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> removeFromCart({
    required String token,
    required String productId,
  }) async {
    try {
      final apiCart = await _remoteDatasource.removeFromCart(
        token: token,
        productId: productId,
      );
      return Right(apiCart.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to remove from cart',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> clearCart({required String token}) async {
    try {
      final apiCart = await _remoteDatasource.clearCart(token: token);
      return Right(apiCart.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to clear cart',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getCartCount({required String token}) async {
    try {
      final count = await _remoteDatasource.getCartCount(token: token);
      return Right(count);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to get cart count',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
