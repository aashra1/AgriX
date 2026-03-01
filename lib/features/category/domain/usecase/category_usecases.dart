import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/category/data/repository/category_repository.dart';
import 'package:agrix/features/category/domain/entity/category_entity.dart';
import 'package:agrix/features/category/domain/repository/category_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Get Categories Usecase
class GetCategoriesUsecaseParams extends Equatable {
  @override
  List<Object?> get props => [];
}

final getCategoriesUsecaseProvider = Provider<GetCategoriesUsecase>((ref) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return GetCategoriesUsecase(categoryRepository: categoryRepository);
});

class GetCategoriesUsecase {
  final ICategoryRepository _categoryRepository;

  GetCategoriesUsecase({required ICategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return _categoryRepository.getCategories();
  }
}
