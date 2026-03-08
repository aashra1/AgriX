import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/services/connectivity/network_infor.dart';
import 'package:agrix/features/business/auth/data/datasource/business_auth_datasource.dart';
import 'package:agrix/features/business/auth/data/datasource/local/business_auth_local_datasource.dart';
import 'package:agrix/features/business/auth/data/datasource/remote/business_auth_remote_datasource.dart';
import 'package:agrix/features/business/auth/data/models/business_auth_api_model.dart';
import 'package:agrix/features/business/auth/data/models/business_auth_hive_model.dart';
import 'package:agrix/features/business/auth/domain/entities/business_auth_entity.dart';
import 'package:agrix/features/business/auth/domain/repository/business_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessAuthRepositoryProvider = Provider<IBusinessAuthRepository>((ref) {
  final authLocalDatasource = ref.read(businessAuthLocalDatasourceProvider);
  final authRemoteDatasource = ref.read(businessAuthRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return BusinessAuthRepository(
    authLocalDataSource: authLocalDatasource,
    authRemoteDatasource: authRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class BusinessAuthRepository implements IBusinessAuthRepository {
  final IBusinessAuthLocalDatasource _authLocalDatasource;
  final IBusinessAuthRemoteDatasource _authRemoteDatasource;
  final NetworkInfo _networkInfo;

  BusinessAuthRepository({
    required IBusinessAuthLocalDatasource authLocalDataSource,
    required IBusinessAuthRemoteDatasource authRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _authLocalDatasource = authLocalDataSource,
       _authRemoteDatasource = authRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, BusinessAuthEntity>> loginBusiness(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDatasource.loginBusiness(
          email,
          password,
        );
        if (apiModel != null) {
          final entity = apiModel.toBusinessAuthEntity();
          return Right(entity);
        }
        return const Left(ApiFailure(message: "Invalid Credentials"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? "Login Failed",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final business = await _authLocalDatasource.loginBusiness(
          email,
          password,
        );
        if (business != null) {
          final businessEntity = business.toEntity();
          return Right(businessEntity);
        }
        return Left(LocalDatabaseFailure(message: "Failed to Log In Business"));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> registerBusiness(
    BusinessAuthEntity entity, {
    String? imagePath,
  }
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = BusinessAuthApiModel.fromBusinessAuthEntity(entity);
        final result = await _authRemoteDatasource.registerBusiness(
          apiModel,
          imagePath: imagePath,
        );
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? "Registration Failed",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    } else {
      try {
        final model = BusinessAuthHiveModel.fromEntity(entity);
        await _authLocalDatasource.registerBusiness(model);
        return Right({
          'business': entity,
          'message': 'Registered locally. Sync when online.',
        });
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
  
  @override
  Future<Either<Failure, BusinessAuthEntity>> uploadBusinessDocument({
    required String businessId,
    required String documentPath,
    required String token,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDatasource.uploadBusinessDocument(
          businessId: businessId,
          documentPath: documentPath,
          token: token,
        );
        final entity = apiModel.toBusinessAuthEntity();
        return Right(entity);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? "Document Upload Failed",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        // Update local storage with document path
        final updatedBusiness = await _authLocalDatasource.updateBusinessDocument(
          businessId: businessId,
          documentPath: documentPath,
        );
        
        if (updatedBusiness != null) {
          final entity = updatedBusiness.toEntity();
          return Right(entity);
        }
        return Left(LocalDatabaseFailure(message: "Failed to save document locally"));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
