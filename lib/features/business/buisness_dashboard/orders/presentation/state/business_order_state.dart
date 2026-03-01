import 'package:agrix/features/business/buisness_dashboard/orders/domain/entity/business_order_entity.dart';
import 'package:equatable/equatable.dart';

enum BusinessOrderStatus { initial, loading, loaded, updating, updated, error }

class BusinessOrderState extends Equatable {
  final BusinessOrderStatus status;
  final List<BusinessOrderEntity> orders;
  final BusinessOrderEntity? selectedOrder;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;

  const BusinessOrderState({
    this.status = BusinessOrderStatus.initial,
    this.orders = const [],
    this.selectedOrder,
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  BusinessOrderState copyWith({
    BusinessOrderStatus? status,
    List<BusinessOrderEntity>? orders,
    BusinessOrderEntity? selectedOrder,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return BusinessOrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    status,
    orders,
    selectedOrder,
    errorMessage,
    currentPage,
    hasReachedMax,
  ];
}
