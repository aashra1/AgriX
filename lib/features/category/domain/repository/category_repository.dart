import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/category/domain/entity/category_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ICategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
