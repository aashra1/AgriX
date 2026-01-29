class CategoryEntity {
  final String? id;
  final String name;
  final String? description;
  final String? parentCategoryId;
  final String? parentCategoryName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryEntity({
    this.id,
    required this.name,
    this.description,
    this.parentCategoryId,
    this.parentCategoryName,
    this.createdAt,
    this.updatedAt,
  });

  // Method to create updated copy
  CategoryEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? parentCategoryId,
    String? parentCategoryName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      parentCategoryName: parentCategoryName ?? this.parentCategoryName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Check if category has parent
  bool get hasParent =>
      parentCategoryId != null && parentCategoryId!.isNotEmpty;

  // Check if category is root (no parent)
  bool get isRoot => !hasParent;
}
