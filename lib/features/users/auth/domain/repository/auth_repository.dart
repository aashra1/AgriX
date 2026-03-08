import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/users/auth/domain/entities/auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IAuthRepository {
  Future<Either<Failure, AuthEntity>> loginUser(String email, String password);
  Future<Either<Failure, bool>> registerUser(
    AuthEntity entity, {
    String? imagePath,
  });
}
