import 'package:agrix/features/auth/data/models/auth_hive_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/auth_datasource.dart';
import '../datasource/local/auth_local_datasource.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.read(authLocalDatasourceProvider);
  return AuthRepository(authDatasource: authDatasource);
});

class AuthRepository implements IAuthRepository {
  final IAuthDatasource _authDataSource;

  AuthRepository({required IAuthDatasource authDatasource})
    : _authDataSource = authDatasource;

  @override
  Future<Either<Failure, AuthEntity>> loginUser(String email, String password) async {
  try {
      final user= await _authDataSource.loginUser(email, password);
      if (user != null) {
        final userEntity= user.toEntity();
        return Right(userEntity);
      }
      return Left(LocalDatabaseFailure(message: "Failed to Log In User"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> registerUser(AuthEntity entity) async {
    try {
      // Here We convert the incoming entity into model.
      final model = AuthHiveModel.fromEntity(entity);
      final result = await _authDataSource.registerUser(model);
      if (result) {
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: "Failed to Register User"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  }

