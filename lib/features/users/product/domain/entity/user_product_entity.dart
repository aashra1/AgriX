import 'package:equatable/equatable.dart';

class UserProductEntity extends Equatable {
  final String? id;
  final String businessId;
  final String? businessName;
  final String name;
  final String categoryId;
  final String? categoryName;
  final String? brand;
  final double price;
  final double discount;
  final int stock;
  final double? weight;
  final String? unitType;
  final String? shortDescription;
  final String? fullDescription;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProductEntity({
    this.id,
    required this.businessId,
    this.businessName,
    required this.name,
    required this.categoryId,
    this.categoryName,
    this.brand,
    required this.price,
    this.discount = 0.0,
    required this.stock,
    this.weight,
    this.unitType,
    this.shortDescription,
    this.fullDescription,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  UserProductEntity copyWith({
    String? id,
    String? businessId,
    String? businessName,
    String? name,
    String? categoryId,
    String? categoryName,
    String? brand,
    double? price,
    double? discount,
    int? stock,
    double? weight,
    String? unitType,
    String? shortDescription,
    String? fullDescription,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProductEntity(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      stock: stock ?? this.stock,
      weight: weight ?? this.weight,
      unitType: unitType ?? this.unitType,
      shortDescription: shortDescription ?? this.shortDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get discountedPrice {
    if (discount <= 0) return price;
    return price * (1 - discount / 100);
  }

  @override
  List<Object?> get props => [
    id,
    businessId,
    businessName,
    name,
    categoryId,
    categoryName,
    brand,
    price,
    discount,
    stock,
    weight,
    unitType,
    shortDescription,
    fullDescription,
    image,
    createdAt,
    updatedAt,
  ];
}
