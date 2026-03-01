import 'package:agrix/features/business/buisness_dashboard/payments/domain/entity/business_transaction_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/domain/usecase/business_transaction_usecase.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/presentation/state/business_transaction_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessWalletViewModelProvider =
    NotifierProvider<BusinessWalletViewModel, BusinessWalletState>(
      () => BusinessWalletViewModel(),
    );

class BusinessWalletViewModel extends Notifier<BusinessWalletState> {
  late GetWalletBalanceUsecase _getWalletBalanceUsecase;
  late GetTransactionsUsecase _getTransactionsUsecase;

  @override
  BusinessWalletState build() {
    _getWalletBalanceUsecase = ref.read(getWalletBalanceUsecaseProvider);
    _getTransactionsUsecase = ref.read(getTransactionsUsecaseProvider);
    return const BusinessWalletState();
  }

  Future<void> loadWalletData({
    required String token,
    int page = 1,
    int limit = 10,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = state.copyWith(
        status: BusinessWalletStatus.loading,
        transactions: [],
        hasReachedMax: false,
      );
    } else if (state.hasReachedMax && !refresh) {
      return;
    }

    state = state.copyWith(status: BusinessWalletStatus.loading);

    final balanceResult = await _getWalletBalanceUsecase.call(
      GetWalletBalanceUsecaseParams(token: token),
    );

    balanceResult.fold(
      (failure) {
        state = state.copyWith(
          status: BusinessWalletStatus.error,
          errorMessage: failure.message,
        );
      },
      (balance) {
        state = state.copyWith(balance: balance);
      },
    );

    final txResult = await _getTransactionsUsecase.call(
      GetTransactionsUsecaseParams(token: token, page: page, limit: limit),
    );

    txResult.fold(
      (failure) {
        state = state.copyWith(
          status: BusinessWalletStatus.error,
          errorMessage: failure.message,
        );
      },
      (result) {
        final transactions =
            result['transactions'] as List<BusinessTransactionEntity>;
        final pagination = result['pagination'] as Map<String, int>;

        final updatedTransactions =
            refresh || page == 1
                ? transactions
                : [...state.transactions, ...transactions];

        state = state.copyWith(
          status: BusinessWalletStatus.loaded,
          transactions: updatedTransactions,
          currentPage: pagination['page'] ?? page,
          totalPages: pagination['pages'] ?? 1,
          totalItems: pagination['total'] ?? 0,
          hasReachedMax: transactions.length < limit,
        );
      },
    );
  }

  Future<void> refreshWallet(String token) async {
    await loadWalletData(token: token, page: 1, refresh: true);
  }

  Future<void> loadNextPage(String token) async {
    if (!state.hasReachedMax && state.currentPage < state.totalPages) {
      await loadWalletData(
        token: token,
        page: state.currentPage + 1,
        limit: 10,
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = const BusinessWalletState();
  }
}
