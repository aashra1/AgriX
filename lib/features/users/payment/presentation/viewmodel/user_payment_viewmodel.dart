import 'package:agrix/features/users/payment/domain/usecase/user_payment_usecase.dart';
import 'package:agrix/features/users/payment/presentation/state/user_payment_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userPaymentViewModelProvider =
    NotifierProvider<UserPaymentViewModel, UserPaymentState>(
      () => UserPaymentViewModel(),
    );

class UserPaymentViewModel extends Notifier<UserPaymentState> {
  late InitiateKhaltiPaymentUsecase _initiateKhaltiPaymentUsecase;
  late VerifyKhaltiPaymentUsecase _verifyKhaltiPaymentUsecase;
  late GetPaymentByOrderIdUsecase _getPaymentByOrderIdUsecase;
  late GetUserPaymentsUsecase _getUserPaymentsUsecase;

  @override
  UserPaymentState build() {
    _initiateKhaltiPaymentUsecase = ref.read(
      initiateKhaltiPaymentUsecaseProvider,
    );
    _verifyKhaltiPaymentUsecase = ref.read(verifyKhaltiPaymentUsecaseProvider);
    _getPaymentByOrderIdUsecase = ref.read(getPaymentByOrderIdUsecaseProvider);
    _getUserPaymentsUsecase = ref.read(getUserPaymentsUsecaseProvider);
    return const UserPaymentState();
  }

  Future<void> initiateKhaltiPayment({
    required String token,
    required String orderId,
    required double amount,
    required String returnUrl,
  }) async {
    state = state.copyWith(status: UserPaymentViewStatus.initiating);

    final params = InitiateKhaltiPaymentUsecaseParams(
      token: token,
      orderId: orderId,
      amount: amount,
      returnUrl: returnUrl,
    );

    final result = await _initiateKhaltiPaymentUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserPaymentViewStatus.error,
          errorMessage: failure.message,
        );
      },
      (initiatedPayment) {
        state = state.copyWith(
          status: UserPaymentViewStatus.success,
          initiatedPayment: initiatedPayment,
        );
      },
    );
  }

  Future<void> verifyKhaltiPayment({
    required String token,
    required String pidx,
    required String orderId,
  }) async {
    state = state.copyWith(status: UserPaymentViewStatus.verifying);

    final params = VerifyKhaltiPaymentUsecaseParams(
      token: token,
      pidx: pidx,
      orderId: orderId,
    );

    final result = await _verifyKhaltiPaymentUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserPaymentViewStatus.error,
          errorMessage: failure.message,
        );
      },
      (payment) {
        state = state.copyWith(
          status: UserPaymentViewStatus.success,
          currentPayment: payment,
        );
      },
    );
  }

  Future<void> getPaymentByOrderId({
    required String token,
    required String orderId,
  }) async {
    state = state.copyWith(status: UserPaymentViewStatus.loading);

    final params = GetPaymentByOrderIdUsecaseParams(
      token: token,
      orderId: orderId,
    );

    final result = await _getPaymentByOrderIdUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserPaymentViewStatus.error,
          errorMessage: failure.message,
        );
      },
      (payment) {
        state = state.copyWith(
          status: UserPaymentViewStatus.loaded,
          currentPayment: payment,
        );
      },
    );
  }

  Future<void> getUserPayments({
    required String token,
    int page = 1,
    int limit = 10,
    String? status,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = state.copyWith(
        status: UserPaymentViewStatus.loading,
        payments: [],
      );
    } else if (state.hasReachedMax ||
        state.status == UserPaymentViewStatus.loading) {
      return;
    }

    state = state.copyWith(status: UserPaymentViewStatus.loading);

    final params = GetUserPaymentsUsecaseParams(
      token: token,
      page: page,
      limit: limit,
      status: status,
    );

    final result = await _getUserPaymentsUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserPaymentViewStatus.error,
          errorMessage: failure.message,
        );
      },
      (payments) {
        final updatedPayments =
            refresh || page == 1 ? payments : [...state.payments, ...payments];

        state = state.copyWith(
          status: UserPaymentViewStatus.loaded,
          payments: updatedPayments,
          currentPage: page,
          hasReachedMax: payments.length < limit,
        );
      },
    );
  }

  void resetState() {
    state = const UserPaymentState();
  }

  void clearError() {
    state = UserPaymentState(
      status: state.status,
      payments: state.payments,
      currentPayment: state.currentPayment,
      initiatedPayment: state.initiatedPayment,
      errorMessage: null,
      currentPage: state.currentPage,
      hasReachedMax: state.hasReachedMax,
    );
  }
}
