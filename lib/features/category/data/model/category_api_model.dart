

import 'package:agrix/features/category/domain/entity/category_entity.dart';

class CategoryApiModel {
  final String? id;
  final String name;
  final String? description;
  final String? parentCategoryId;
  final String? parentCategoryName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryApiModel({
    this.id,
    required this.name,
    this.description,
    this.parentCategoryId,
    this.parentCategoryName,
    this.createdAt,
    this.updatedAt,
  });

  // From API JSON
  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> categoryData;
    
    if (json.containsKey('category') && json['category'] != null) {
      categoryData = json['category'] as Map<String, dynamic>;
    } else {
      categoryData = json;
    }

    return CategoryApiModel(
      id: categoryData['_id'] as String?,
      name: categoryData['name'] as String? ?? '',
      description: categoryData['description'] as String?,
      parentCategoryId: (categoryData['parentCategory'] as Map<String, dynamic>?)?['_id'] as String?,
      parentCategoryName: (categoryData['parentCategory'] as Map<String, dynamic>?)?['name'] as String?,
      createdAt: categoryData['createdAt'] != null 
          ? DateTime.parse(categoryData['createdAt'] as String) 
          : null,
      updatedAt: categoryData['updatedAt'] != null 
          ? DateTime.parse(categoryData['updatedAt'] as String) 
          : null,
    );
  }

  // To JSON for API requests
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
    };

    if (description != null && description!.isNotEmpty) {
      data['description'] = description;
    }
    if (parentCategoryId != null && parentCategoryId!.isNotEmpty) {
      data['parentCategory'] = parentCategoryId;
    }

    return data;
  }

  // To CategoryEntity
  CategoryEntity toCategoryEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      description: description,
      parentCategoryId: parentCategoryId,
      parentCategoryName: parentCategoryName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // From CategoryEntity
  factory CategoryApiModel.fromCategoryEntity(CategoryEntity entity) {
    return CategoryApiModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      parentCategoryId: entity.parentCategoryId,
      parentCategoryName: entity.parentCategoryName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // To Entity List
  static List<CategoryEntity> toCategoryEntityList(List<CategoryApiModel> models) {
    return models.map((model) => model.toCategoryEntity()).toList();
  }
}