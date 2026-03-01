import 'package:agrix/features/users/product/domain/entity/user_product_entity.dart';
import 'package:equatable/equatable.dart';

enum UserProductStatus { initial, loading, loaded, error }

class UserProductState extends Equatable {
  final UserProductStatus status;
  final List<UserProductEntity> products;
  final UserProductEntity? selectedProduct;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;

  const UserProductState({
    this.status = UserProductStatus.initial,
    this.products = const [],
    this.selectedProduct,
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  UserProductState copyWith({
    UserProductStatus? status,
    List<UserProductEntity>? products,
    UserProductEntity? selectedProduct,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return UserProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    selectedProduct,
    errorMessage,
    currentPage,
    hasReachedMax,
  ];
}
