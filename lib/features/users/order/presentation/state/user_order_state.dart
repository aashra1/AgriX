import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:equatable/equatable.dart';

enum UserOrderViewStatus { initial, loading, loaded, creating, created, error }

class UserOrderState extends Equatable {
  final UserOrderViewStatus status;
  final List<UserOrderEntity> orders;
  final UserOrderEntity? currentOrder;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;
  final bool isCreating;

  const UserOrderState({
    this.status = UserOrderViewStatus.initial,
    this.orders = const [],
    this.currentOrder,
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isCreating = false,
  });

  UserOrderState copyWith({
    UserOrderViewStatus? status,
    List<UserOrderEntity>? orders,
    UserOrderEntity? currentOrder,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
    bool? isCreating,
  }) {
    return UserOrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      currentOrder: currentOrder ?? this.currentOrder,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isCreating: isCreating ?? this.isCreating,
    );
  }

  @override
  List<Object?> get props => [
    status,
    orders,
    currentOrder,
    errorMessage,
    currentPage,
    hasReachedMax,
    isCreating,
  ];
}
