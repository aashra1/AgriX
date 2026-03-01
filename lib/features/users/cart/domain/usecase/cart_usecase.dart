import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/usecases/app_usecases.dart';
import 'package:agrix/features/users/cart/data/repository/cart_repository.dart';
import 'package:agrix/features/users/cart/domain/entity/cart_entity.dart';
import 'package:agrix/features/users/cart/domain/repository/cart_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCartUsecaseProvider = Provider<GetCartUsecase>((ref) {
  final repository = ref.read(cartRepositoryProvider);
  return GetCartUsecase(repository: repository);
});

final addToCartUsecaseProvider = Provider<AddToCartUsecase>((ref) {
  final repository = ref.read(cartRepositoryProvider);
  return AddToCartUsecase(repository: repository);
});

final updateCartItemUsecaseProvider = Provider<UpdateCartItemUsecase>((ref) {
  final repository = ref.read(cartRepositoryProvider);
  return UpdateCartItemUsecase(repository: repository);
});

final removeFromCartUsecaseProvider = Provider<RemoveFromCartUsecase>((ref) {
  final repository = ref.read(cartRepositoryProvider);
  return RemoveFromCartUsecase(repository: repository);
});

final clearCartUsecaseProvider = Provider<ClearCartUsecase>((ref) {
  final repository = ref.read(cartRepositoryProvider);
  return ClearCartUsecase(repository: repository);
});

final getCartCountUsecaseProvider = Provider<GetCartCountUsecase>((ref) {
  final repository = ref.read(cartRepositoryProvider);
  return GetCartCountUsecase(repository: repository);
});

class GetCartUsecaseParams extends Equatable {
  final String token;
  const GetCartUsecaseParams({required this.token});

  @override
  List<Object?> get props => [token];
}

class GetCartUsecase
    implements UsecaseWithParams<CartEntity, GetCartUsecaseParams> {
  final ICartRepository _repository;
  GetCartUsecase({required ICartRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CartEntity>> call(GetCartUsecaseParams params) {
    return _repository.getCart(token: params.token);
  }
}

class AddToCartUsecaseParams extends Equatable {
  final String token;
  final String productId;
  final int quantity;

  const AddToCartUsecaseParams({
    required this.token,
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [token, productId, quantity];
}

class AddToCartUsecase
    implements UsecaseWithParams<CartEntity, AddToCartUsecaseParams> {
  final ICartRepository _repository;
  AddToCartUsecase({required ICartRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CartEntity>> call(AddToCartUsecaseParams params) {
    return _repository.addToCart(
      token: params.token,
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}

class UpdateCartItemUsecaseParams extends Equatable {
  final String token;
  final String productId;
  final int quantity;

  const UpdateCartItemUsecaseParams({
    required this.token,
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [token, productId, quantity];
}

class UpdateCartItemUsecase
    implements UsecaseWithParams<CartEntity, UpdateCartItemUsecaseParams> {
  final ICartRepository _repository;
  UpdateCartItemUsecase({required ICartRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CartEntity>> call(UpdateCartItemUsecaseParams params) {
    return _repository.updateCartItem(
      token: params.token,
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}

class RemoveFromCartUsecaseParams extends Equatable {
  final String token;
  final String productId;

  const RemoveFromCartUsecaseParams({
    required this.token,
    required this.productId,
  });

  @override
  List<Object?> get props => [token, productId];
}

class RemoveFromCartUsecase
    implements UsecaseWithParams<CartEntity, RemoveFromCartUsecaseParams> {
  final ICartRepository _repository;
  RemoveFromCartUsecase({required ICartRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CartEntity>> call(RemoveFromCartUsecaseParams params) {
    return _repository.removeFromCart(
      token: params.token,
      productId: params.productId,
    );
  }
}

class ClearCartUsecaseParams extends Equatable {
  final String token;
  const ClearCartUsecaseParams({required this.token});

  @override
  List<Object?> get props => [token];
}

class ClearCartUsecase
    implements UsecaseWithParams<CartEntity, ClearCartUsecaseParams> {
  final ICartRepository _repository;
  ClearCartUsecase({required ICartRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, CartEntity>> call(ClearCartUsecaseParams params) {
    return _repository.clearCart(token: params.token);
  }
}

class GetCartCountUsecaseParams extends Equatable {
  final String token;
  const GetCartCountUsecaseParams({required this.token});

  @override
  List<Object?> get props => [token];
}

class GetCartCountUsecase
    implements UsecaseWithParams<int, GetCartCountUsecaseParams> {
  final ICartRepository _repository;
  GetCartCountUsecase({required ICartRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, int>> call(GetCartCountUsecaseParams params) {
    return _repository.getCartCount(token: params.token);
  }
}
