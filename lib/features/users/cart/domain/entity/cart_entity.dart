// lib/features/cart/domain/entity/cart_entity.dart
import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String? id;
  final String productId;
  final int quantity;
  final double price;
  final double discount;
  final String businessId;
  final String? businessName;
  final String name;
  final String? image;

  const CartItemEntity({
    this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    this.discount = 0.0,
    required this.businessId,
    this.businessName,
    required this.name,
    this.image,
  });

  CartItemEntity copyWith({
    String? id,
    String? productId,
    int? quantity,
    double? price,
    double? discount,
    String? businessId,
    String? businessName,
    String? name,
    String? image,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  double get itemTotal {
    final itemTotal = price * quantity;
    final discountAmount = itemTotal * (discount / 100);
    return itemTotal - discountAmount;
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    quantity,
    price,
    discount,
    businessId,
    businessName,
    name,
    image,
  ];
}

class CartEntity extends Equatable {
  final String? id;
  final String userId;
  final List<CartItemEntity> items;
  final double totalAmount;
  final int totalItems;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CartEntity({
    this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.totalItems,
    this.createdAt,
    this.updatedAt,
  });

  CartEntity copyWith({
    String? id,
    String? userId,
    List<CartItemEntity>? items,
    double? totalAmount,
    int? totalItems,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      totalItems: totalItems ?? this.totalItems,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    totalAmount,
    totalItems,
    createdAt,
    updatedAt,
  ];
}
