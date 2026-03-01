import 'package:agrix/features/business/buisness_dashboard/product/domain/entity/business_product_entity.dart';

class ProductApiModel {
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

  ProductApiModel({
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

  // From API JSON
  factory ProductApiModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> productData;

    // Check if response has nested 'product' field
    if (json.containsKey('product') && json['product'] != null) {
      productData = json['product'] as Map<String, dynamic>;
    } else {
      productData = json;
    }

    // Handle business field - it can be String or Object
    String businessId;
    if (productData['business'] is String) {
      businessId = productData['business'] as String;
    } else if (productData['business'] is Map<String, dynamic>) {
      businessId =
          (productData['business'] as Map<String, dynamic>)['_id'] as String? ??
          '';
    } else {
      businessId = '';
    }

    // Handle category field - it can be String or Object
    String categoryId;
    String? categoryName;
    if (productData['category'] is String) {
      categoryId = productData['category'] as String;
      categoryName = null;
    } else if (productData['category'] is Map<String, dynamic>) {
      final categoryMap = productData['category'] as Map<String, dynamic>;
      categoryId = categoryMap['_id'] as String? ?? '';
      categoryName = categoryMap['name'] as String?;
    } else {
      categoryId = '';
      categoryName = null;
    }

    return ProductApiModel(
      id: productData['_id'] as String?,
      businessId: businessId,
      name: (productData['name'] as String?) ?? '',
      categoryId: categoryId,
      categoryName: categoryName,
      brand: productData['brand'] as String?,
      price: (productData['price'] as num?)?.toDouble() ?? 0.0,
      discount: (productData['discount'] as num?)?.toDouble() ?? 0.0,
      stock: (productData['stock'] as num?)?.toInt() ?? 0,
      weight: (productData['weight'] as num?)?.toDouble(),
      unitType: productData['unitType'] as String?,
      shortDescription: productData['shortDescription'] as String?,
      fullDescription: productData['fullDescription'] as String?,
      image: productData['image'] as String?,
      createdAt:
          productData['createdAt'] != null
              ? DateTime.parse(productData['createdAt'] as String)
              : null,
      updatedAt:
          productData['updatedAt'] != null
              ? DateTime.parse(productData['updatedAt'] as String)
              : null,
    );
  }

  // To JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': categoryId,
      'brand': brand,
      'price': price,
      'discount': discount,
      'stock': stock,
      'weight': weight,
      'unitType': unitType,
      'shortDescription': shortDescription,
      'fullDescription': fullDescription,
    };
  }

  // To ProductEntity
  ProductEntity toProductEntity() {
    return ProductEntity(
      id: id,
      businessId: businessId,
      name: name,
      categoryId: categoryId,
      categoryName: categoryName,
      brand: brand,
      price: price,
      discount: discount,
      stock: stock,
      weight: weight,
      unitType: unitType,
      shortDescription: shortDescription,
      fullDescription: fullDescription,
      image: image,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // From ProductEntity
  factory ProductApiModel.fromProductEntity(ProductEntity entity) {
    return ProductApiModel(
      id: entity.id,
      businessId: entity.businessId,
      name: entity.name,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      brand: entity.brand,
      price: entity.price,
      discount: entity.discount,
      stock: entity.stock,
      weight: entity.weight,
      unitType: entity.unitType,
      shortDescription: entity.shortDescription,
      fullDescription: entity.fullDescription,
      image: entity.image,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // To Entity List
  static List<ProductEntity> toProductEntityList(List<ProductApiModel> models) {
    return models.map((model) => model.toProductEntity()).toList();
  }
}
