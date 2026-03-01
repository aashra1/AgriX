import 'package:agrix/features/business/buisness_dashboard/orders/domain/entity/business_order_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/domain/usecase/business_order_usecases.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/presentation/state/business_order_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessOrderViewModelProvider =
    NotifierProvider<BusinessOrderViewModel, BusinessOrderState>(
      () => BusinessOrderViewModel(),
    );

class BusinessOrderViewModel extends Notifier<BusinessOrderState> {
  late GetBusinessOrdersUsecase _getBusinessOrdersUsecase;
  late GetOrderByIdUsecase _getOrderByIdUsecase;
  UpdateOrderStatusUsecase? _updateOrderStatusUsecase;
  UpdatePaymentStatusUsecase? _updatePaymentStatusUsecase;

  @override
  BusinessOrderState build() {
    _getBusinessOrdersUsecase = ref.read(getBusinessOrdersUsecaseProvider);
    _getOrderByIdUsecase = ref.read(getOrderByIdUsecaseProvider);
    return BusinessOrderState();
  }

  Future<void> getBusinessOrders({
    required String token,
    required String businessId,
    int page = 1,
    int limit = 10,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = state.copyWith(status: BusinessOrderStatus.loading, orders: []);
    } else if (state.hasReachedMax ||
        state.status == BusinessOrderStatus.loading) {
      return;
    }

    state = state.copyWith(status: BusinessOrderStatus.loading);

    final params = GetBusinessOrdersUsecaseParams(
      token: token,
      businessId: businessId,
      page: page,
      limit: limit,
    );

    final result = await _getBusinessOrdersUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: BusinessOrderStatus.error,
          errorMessage: failure.message,
        );
      },
      (orders) {
        final updatedOrders =
            refresh || page == 1 ? orders : [...state.orders, ...orders];

        state = state.copyWith(
          status: BusinessOrderStatus.loaded,
          orders: updatedOrders,
          currentPage: page,
          hasReachedMax: orders.length < limit,
        );
      },
    );
  }

  Future<void> getOrderById({
    required String orderId,
    required String token,
  }) async {
    state = state.copyWith(status: BusinessOrderStatus.loading);

    final params = GetOrderByIdUsecaseParams(orderId: orderId, token: token);

    final result = await _getOrderByIdUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: BusinessOrderStatus.error,
          errorMessage: failure.message,
        );
      },
      (order) {
        state = state.copyWith(
          status: BusinessOrderStatus.loaded,
          selectedOrder: order,
        );
      },
    );
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required String orderStatus,
    String? trackingNumber,
    required String token,
  }) async {
    state = state.copyWith(status: BusinessOrderStatus.updating);

    try {
      _updateOrderStatusUsecase ??= ref.read(updateOrderStatusUsecaseProvider);

      if (_updateOrderStatusUsecase == null) {
        throw Exception("Failed to initialize update order status usecase");
      }

      final params = UpdateOrderStatusUsecaseParams(
        orderId: orderId,
        orderStatus: orderStatus,
        trackingNumber: trackingNumber,
        token: token,
      );

      final result = await _updateOrderStatusUsecase!.call(params);

      result.fold(
        (failure) {
          state = state.copyWith(
            status: BusinessOrderStatus.error,
            errorMessage: failure.message,
          );
        },
        (order) {
          final updatedOrders =
              state.orders.map((o) {
                return o.id == order.id ? order : o;
              }).toList();

          state = state.copyWith(
            status: BusinessOrderStatus.updated,
            orders: updatedOrders,
            selectedOrder: order,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: BusinessOrderStatus.error,
        errorMessage: "Failed to update order status: $e",
      );
    }
  }

  Future<void> updatePaymentStatus({
    required String orderId,
    required String paymentStatus,
    required String token,
  }) async {
    state = state.copyWith(status: BusinessOrderStatus.updating);

    try {
      _updatePaymentStatusUsecase ??= ref.read(
        updatePaymentStatusUsecaseProvider,
      );

      if (_updatePaymentStatusUsecase == null) {
        throw Exception("Failed to initialize update payment status usecase");
      }

      final params = UpdatePaymentStatusUsecaseParams(
        orderId: orderId,
        paymentStatus: paymentStatus,
        token: token,
      );

      final result = await _updatePaymentStatusUsecase!.call(params);

      result.fold(
        (failure) {
          state = state.copyWith(
            status: BusinessOrderStatus.error,
            errorMessage: failure.message,
          );
        },
        (order) {
          final updatedOrders =
              state.orders.map((o) {
                return o.id == order.id ? order : o;
              }).toList();

          state = state.copyWith(
            status: BusinessOrderStatus.updated,
            orders: updatedOrders,
            selectedOrder: order,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: BusinessOrderStatus.error,
        errorMessage: "Failed to update payment status: $e",
      );
    }
  }

  void selectOrder(BusinessOrderEntity order) {
    state = state.copyWith(selectedOrder: order);
  }

  void clearSelection() {
    state = state.copyWith(selectedOrder: null);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = BusinessOrderState();
  }

  void resetStatus() {
    if (state.status == BusinessOrderStatus.updated) {
      state = state.copyWith(status: BusinessOrderStatus.loaded);
    }
  }
}
