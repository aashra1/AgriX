import 'package:agrix/features/business/buisness_dashboard/product/domain/entity/business_product_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'business_product_hive_model.g.dart';

@HiveType(typeId: 3) // Use appropriate typeId
class ProductHiveModel extends HiveObject {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String businessId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String categoryId;

  @HiveField(4)
  final String? categoryName;

  @HiveField(5)
  final String? brand;

  @HiveField(6)
  final double price;

  @HiveField(7)
  final double discount;

  @HiveField(8)
  final int stock;

  @HiveField(9)
  final double? weight;

  @HiveField(10)
  final String? unitType;

  @HiveField(11)
  final String? shortDescription;

  @HiveField(12)
  final String? fullDescription;

  @HiveField(13)
  final String? image;

  @HiveField(14)
  final DateTime? createdAt;

  @HiveField(15)
  final DateTime? updatedAt;

  ProductHiveModel({
    String? productId,
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
  }) : productId = productId ?? const Uuid().v4();

  ProductEntity toEntity() {
    return ProductEntity(
      id: productId,
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

  factory ProductHiveModel.fromEntity(ProductEntity entity) {
    return ProductHiveModel(
      productId: entity.id,
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

  static List<ProductEntity> toEntityList(List<ProductHiveModel> models) {
    return models.map((e) => e.toEntity()).toList();
  }
}
