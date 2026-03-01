import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:agrix/features/users/order/domain/usecase/user_order_usecase.dart';
import 'package:agrix/features/users/order/presentation/state/user_order_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userOrderViewModelProvider =
    NotifierProvider<UserOrderViewModel, UserOrderState>(
      () => UserOrderViewModel(),
    );

class UserOrderViewModel extends Notifier<UserOrderState> {
  late CreateUserOrderUsecase _createOrderUsecase;
  late GetUserOrdersUsecase _getOrdersUsecase;
  late GetUserOrderByIdUsecase _getOrderByIdUsecase;

  @override
  UserOrderState build() {
    _createOrderUsecase = ref.read(createUserOrderUsecaseProvider);
    _getOrdersUsecase = ref.read(getUserOrdersUsecaseProvider);
    _getOrderByIdUsecase = ref.read(getUserOrderByIdUsecaseProvider);
    return const UserOrderState();
  }

  Future<void> createOrder({
    required String token,
    required Map<String, dynamic> orderData,
  }) async {
    state = state.copyWith(
      status: UserOrderViewStatus.creating,
      isCreating: true,
    );

    final params = CreateUserOrderUsecaseParams(
      token: token,
      orderData: orderData,
    );

    final result = await _createOrderUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserOrderViewStatus.error,
          errorMessage: failure.message,
          isCreating: false,
        );
      },
      (order) {
        final updatedOrders = List<UserOrderEntity>.from(state.orders)
          ..add(order);
        state = state.copyWith(
          status: UserOrderViewStatus.created,
          orders: updatedOrders,
          currentOrder: order,
          isCreating: false,
        );
      },
    );
  }

  Future<void> getUserOrders({
    required String token,
    int page = 1,
    int limit = 10,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = state.copyWith(status: UserOrderViewStatus.loading, orders: []);
    } else if (state.hasReachedMax ||
        state.status == UserOrderViewStatus.loading) {
      return;
    }

    state = state.copyWith(status: UserOrderViewStatus.loading);

    final params = GetUserOrdersUsecaseParams(
      token: token,
      page: page,
      limit: limit,
      refresh: refresh,
    );

    final result = await _getOrdersUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserOrderViewStatus.error,
          errorMessage: failure.message,
        );
      },
      (orders) {
        final updatedOrders =
            refresh || page == 1 ? orders : [...state.orders, ...orders];

        state = state.copyWith(
          status: UserOrderViewStatus.loaded,
          orders: updatedOrders,
          currentPage: page,
          hasReachedMax: orders.length < limit,
        );
      },
    );
  }

  Future<void> getOrderById({
    required String token,
    required String orderId,
  }) async {
    state = state.copyWith(status: UserOrderViewStatus.loading);

    final params = GetUserOrderByIdUsecaseParams(
      token: token,
      orderId: orderId,
    );

    final result = await _getOrderByIdUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserOrderViewStatus.error,
          errorMessage: failure.message,
        );
      },
      (order) {
        state = state.copyWith(
          status: UserOrderViewStatus.loaded,
          currentOrder: order,
        );
      },
    );
  }

  void resetStatus() {
    if (state.status == UserOrderViewStatus.created) {
      state = state.copyWith(status: UserOrderViewStatus.loaded);
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = const UserOrderState();
  }
}
