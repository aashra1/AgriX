import 'package:agrix/features/category/domain/entity/category_entity.dart';
import 'package:agrix/features/category/presentation/state/category_state.dart';
import 'package:agrix/features/category/presentation/usecase/category_usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryViewModelProvider =
    NotifierProvider<CategoryViewModel, CategoryState>(
      () => CategoryViewModel(),
    );

class CategoryViewModel extends Notifier<CategoryState> {
  late final GetCategoriesUsecase _getCategoriesUsecase;

  @override
  CategoryState build() {
    _getCategoriesUsecase = ref.read(getCategoriesUsecaseProvider);
    return CategoryState();
  }

  // Get Categories - used by both User and Business
  Future<void> getCategories() async {
    state = state.copyWith(status: CategoryStatus.loading);

    final result = await _getCategoriesUsecase.call();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        );
      },
      (categories) {
        state = state.copyWith(
          status: CategoryStatus.loaded,
          categories: categories,
        );
      },
    );
  }

  // Select Category (for product filtering)
  void selectCategory(CategoryEntity category) {
    state = state.copyWith(selectedCategory: category);
  }

  // Clear Selection
  void clearSelection() {
    state = state.copyWith(selectedCategory: null);
  }

  // Clear Error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  // Reset State
  void reset() {
    state = CategoryState();
  }
}
