import 'package:agrix/features/business/buisness_dashboard/payments/domain/entity/business_transaction_entity.dart';
import 'package:equatable/equatable.dart';

enum BusinessWalletStatus { initial, loading, loaded, error }

class BusinessWalletState extends Equatable {
  final BusinessWalletStatus status;
  final double balance;
  final String currency;
  final List<BusinessTransactionEntity> transactions;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasReachedMax;

  const BusinessWalletState({
    this.status = BusinessWalletStatus.initial,
    this.balance = 0.0,
    this.currency = 'NPR',
    this.transactions = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.hasReachedMax = false,
  });

  BusinessWalletState copyWith({
    BusinessWalletStatus? status,
    double? balance,
    String? currency,
    List<BusinessTransactionEntity>? transactions,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? hasReachedMax,
  }) {
    return BusinessWalletState(
      status: status ?? this.status,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    status,
    balance,
    currency,
    transactions,
    errorMessage,
    currentPage,
    totalPages,
    totalItems,
    hasReachedMax,
  ];
}
