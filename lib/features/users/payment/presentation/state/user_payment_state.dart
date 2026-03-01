import 'package:agrix/features/users/payment/domain/entity/user_payment_entity.dart';
import 'package:equatable/equatable.dart';

enum UserPaymentViewStatus {
  initial,
  loading,
  loaded,
  initiating,
  verifying,
  success,
  error,
}

class UserPaymentState extends Equatable {
  final UserPaymentViewStatus status;
  final List<UserPaymentEntity> payments;
  final UserPaymentEntity? currentPayment;
  final InitiatePaymentEntity? initiatedPayment;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;

  const UserPaymentState({
    this.status = UserPaymentViewStatus.initial,
    this.payments = const [],
    this.currentPayment,
    this.initiatedPayment,
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  UserPaymentState copyWith({
    UserPaymentViewStatus? status,
    List<UserPaymentEntity>? payments,
    UserPaymentEntity? currentPayment,
    InitiatePaymentEntity? initiatedPayment,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return UserPaymentState(
      status: status ?? this.status,
      payments: payments ?? this.payments,
      currentPayment: currentPayment ?? this.currentPayment,
      initiatedPayment: initiatedPayment ?? this.initiatedPayment,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    status,
    payments,
    currentPayment,
    initiatedPayment,
    errorMessage,
    currentPage,
    hasReachedMax,
  ];
}
