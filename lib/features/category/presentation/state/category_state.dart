import 'package:agrix/features/category/domain/entity/category_entity.dart';

enum CategoryStatus { initial, loading, loaded, error }

class CategoryState {
  final CategoryStatus status;
  final List<CategoryEntity> categories;
  final CategoryEntity? selectedCategory;
  final String? errorMessage;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const [],
    this.selectedCategory,
    this.errorMessage,
  });

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryEntity>? categories,
    CategoryEntity? selectedCategory,
    String? errorMessage,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
