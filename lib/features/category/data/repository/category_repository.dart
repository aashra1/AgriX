import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/services/connectivity/network_infor.dart';
import 'package:agrix/features/category/data/datasource/category_datasource.dart';
import 'package:agrix/features/category/data/datasource/remote/category_remote_datasource.dart';
import 'package:agrix/features/category/domain/entity/category_entity.dart';
import 'package:agrix/features/category/domain/repository/category_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRepositoryProvider = Provider<ICategoryRepository>((ref) {
  final remoteDatasource = ref.read(categoryRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return CategoryRepository(
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class CategoryRepository implements ICategoryRepository {
  final ICategoryRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  CategoryRepository({
    required ICategoryRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    if (!await _networkInfo.isConnected) {
      return Left(ApiFailure(message: 'Network connection required'));
    }

    try {
      final apiCategories = await _remoteDatasource.getCategories();
      final entities =
          apiCategories.map((apiModel) => apiModel.toCategoryEntity()).toList();

      return Right(entities);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch categories',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
