class ProductEntity {
  final String? id;
  final String businessId;
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

  const ProductEntity({
    this.id,
    required this.businessId,
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

  // Method to create updated copy
  ProductEntity copyWith({
    String? id,
    String? businessId,
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
    return ProductEntity(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
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
}
