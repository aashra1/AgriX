import 'package:agrix/features/users/product/domain/entity/user_product_entity.dart';

class UserProductApiModel {
  final String? id;
  final String business;
  final String? businessName;
  final String name;
  final String category;
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
  final String? createdAt;
  final String? updatedAt;

  UserProductApiModel({
    this.id,
    required this.business,
    this.businessName,
    required this.name,
    required this.category,
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

  factory UserProductApiModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> productData;
    if (json.containsKey('product') && json['product'] != null) {
      productData = json['product'] as Map<String, dynamic>;
    } else {
      productData = json;
    }

    String? businessId;
    String? businessName;
    if (productData['business'] != null) {
      if (productData['business'] is Map) {
        businessId = productData['business']['_id']?.toString();
        businessName = productData['business']['businessName']?.toString();
      } else {
        businessId = productData['business']?.toString();
      }
    }

    String? categoryId;
    String? categoryName;
    if (productData['category'] != null) {
      if (productData['category'] is Map) {
        categoryId = productData['category']['_id']?.toString();
        categoryName = productData['category']['name']?.toString();
      } else {
        categoryId = productData['category']?.toString();
      }
    }

    return UserProductApiModel(
      id: productData['_id']?.toString(),
      business: businessId ?? '',
      businessName: businessName,
      name: productData['name']?.toString() ?? '',
      category: categoryId ?? '',
      categoryName: categoryName,
      brand: productData['brand']?.toString(),
      price: (productData['price'] as num?)?.toDouble() ?? 0.0,
      discount: (productData['discount'] as num?)?.toDouble() ?? 0.0,
      stock: (productData['stock'] as num?)?.toInt() ?? 0,
      weight: (productData['weight'] as num?)?.toDouble(),
      unitType: productData['unitType']?.toString(),
      shortDescription: productData['shortDescription']?.toString(),
      fullDescription: productData['fullDescription']?.toString(),
      image: productData['image']?.toString(),
      createdAt: productData['createdAt']?.toString(),
      updatedAt: productData['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'business': business,
      'name': name,
      'category': category,
      if (brand != null) 'brand': brand,
      'price': price,
      'discount': discount,
      'stock': stock,
      if (weight != null) 'weight': weight,
      if (unitType != null) 'unitType': unitType,
      if (shortDescription != null) 'shortDescription': shortDescription,
      if (fullDescription != null) 'fullDescription': fullDescription,
      if (image != null) 'image': image,
    };
  }

  UserProductEntity toEntity() {
    return UserProductEntity(
      id: id,
      businessId: business,
      businessName: businessName,
      name: name,
      categoryId: category,
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
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  static List<UserProductEntity> toEntityList(
    List<UserProductApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}
