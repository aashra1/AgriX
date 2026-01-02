import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/auth/domain/entities/auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> registerUser(AuthEntity entity);
  Future<Either<Failure, AuthEntity>> loginUser(String email, String password);
}
