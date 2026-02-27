import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/users/profile/domain/entity/profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IUserProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile({
    required String token,
  });

  Future<Either<Failure, UserProfileEntity>> updateUserProfile({
    required String token,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    String? imagePath,
  });

  Future<Either<Failure, bool>> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });

  Future<Either<Failure, void>> clearLocalProfile();
}
