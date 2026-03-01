import 'package:agrix/features/users/product/domain/entity/user_product_entity.dart';
import 'package:hive/hive.dart';

part 'user_product_hive_model.g.dart';

@HiveType(typeId: 14)
class UserProductHiveModel {
  @HiveField(0)
  final String? productId;

  @HiveField(1)
  final String businessId;

  @HiveField(2)
  final String? businessName;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final String categoryId;

  @HiveField(5)
  final String? categoryName;

  @HiveField(6)
  final String? brand;

  @HiveField(7)
  final double price;

  @HiveField(8)
  final double discount;

  @HiveField(9)
  final int stock;

  @HiveField(10)
  final double? weight;

  @HiveField(11)
  final String? unitType;

  @HiveField(12)
  final String? shortDescription;

  @HiveField(13)
  final String? fullDescription;

  @HiveField(14)
  final String? image;

  @HiveField(15)
  final DateTime? createdAt;

  @HiveField(16)
  final DateTime? updatedAt;

  UserProductHiveModel({
    this.productId,
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

  factory UserProductHiveModel.fromEntity(UserProductEntity entity) {
    return UserProductHiveModel(
      productId: entity.id,
      businessId: entity.businessId,
      businessName: entity.businessName,
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

  UserProductEntity toEntity() {
    return UserProductEntity(
      id: productId,
      businessId: businessId,
      businessName: businessName,
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

  static List<UserProductEntity> toEntityList(
    List<UserProductHiveModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}
