import 'package:agrix/features/business/buisness_dashboard/product/domain/entity/business_product_entity.dart';
import 'package:equatable/equatable.dart';

enum ProductStatus {
  initial,
  loading,
  loaded,
  adding,
  added,
  updating,
  updated,
  deleting,
  deleted,
  error,
}

class ProductState extends Equatable {
  final ProductStatus status;
  final List<ProductEntity> products;
  final ProductEntity? selectedProduct;
  final String? errorMessage;
  final bool hasReachedMax;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.selectedProduct,
    this.errorMessage,
    this.hasReachedMax = false,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductEntity>? products,
    ProductEntity? selectedProduct,
    String? errorMessage,
    bool? hasReachedMax,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    selectedProduct,
    errorMessage,
    hasReachedMax,
  ];
}
