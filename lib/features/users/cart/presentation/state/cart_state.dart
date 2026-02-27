import 'package:agrix/features/users/cart/domain/entity/cart_entity.dart';
import 'package:equatable/equatable.dart';

enum CartStatus { initial, loading, loaded, updating, updated, error }

class CartState extends Equatable {
  final CartStatus status;
  final CartEntity? cart;
  final String? errorMessage;
  final int itemCount;
  final bool isUpdating;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
    this.itemCount = 0,
    this.isUpdating = false,
  });

  CartState copyWith({
    CartStatus? status,
    CartEntity? cart,
    String? errorMessage,
    int? itemCount,
    bool? isUpdating,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
      itemCount: itemCount ?? this.itemCount,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cart,
    errorMessage,
    itemCount,
    isUpdating,
  ];
}
