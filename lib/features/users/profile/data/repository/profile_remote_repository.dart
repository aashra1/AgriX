import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/services/connectivity/network_infor.dart';
import 'package:agrix/features/users/profile/data/datasource/local/profile_local_datasource.dart';
import 'package:agrix/features/users/profile/data/datasource/profile_datasource.dart';
import 'package:agrix/features/users/profile/data/datasource/remote/profile_remote_datasource.dart';
import 'package:agrix/features/users/profile/data/model/profile_hive_model.dart';
import 'package:agrix/features/users/profile/domain/entity/profile_entity.dart';
import 'package:agrix/features/users/profile/domain/repository/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileRepositoryProvider = Provider<IUserProfileRepository>((ref) {
  final localDatasource = ref.read(userProfileLocalDatasourceProvider);
  final remoteDatasource = ref.read(userProfileRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return UserProfileRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class UserProfileRepository implements IUserProfileRepository {
  final IUserProfileLocalDatasource _localDatasource;
  final IUserProfileRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  UserProfileRepository({
    required IUserProfileLocalDatasource localDatasource,
    required IUserProfileRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _localDatasource = localDatasource,
       _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile({
    required String token,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected == true) {
        final apiModel = await _remoteDatasource.getUserProfile(token: token);

        // Save to local storage
        final hiveModel = UserProfileHiveModel.fromEntity(apiModel.toEntity());
        await _localDatasource.saveProfile(hiveModel);

        return Right(apiModel.toEntity());
      } else {
        // Offline: Get from local database
        final localProfile = await _localDatasource.getProfile();
        if (localProfile != null) {
          return Right(localProfile.toEntity());
        }
        return Left(LocalDatabaseFailure(message: 'No cached profile found'));
      }
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? 'Failed to fetch user profile',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      if (e.toString().contains('LocalDatabaseFailure') ||
          e.toString().contains('Hive') ||
          e.toString().contains('local')) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateUserProfile({
    required String token,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    String? imagePath,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      final profileData = <String, dynamic>{};
      if (fullName != null && fullName.isNotEmpty)
        profileData['fullName'] = fullName;
      if (email != null && email.isNotEmpty) profileData['email'] = email;
      if (phoneNumber != null && phoneNumber.isNotEmpty)
        profileData['phoneNumber'] = phoneNumber;
      if (address != null && address.isNotEmpty)
        profileData['address'] = address;

      if (isConnected == true) {
        final apiModel = await _remoteDatasource.updateUserProfile(
          token: token,
          profileData: profileData,
          imagePath: imagePath,
        );

        final hiveModel = UserProfileHiveModel.fromEntity(apiModel.toEntity());
        await _localDatasource.updateProfile(hiveModel);

        return Right(apiModel.toEntity());
      } else {
        return Left(
          LocalDatabaseFailure(message: 'Cannot update profile while offline'),
        );
      }
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? 'Failed to update user profile',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected != true) {
        return Left(
          LocalDatabaseFailure(message: 'Cannot change password while offline'),
        );
      }

      final success = await _remoteDatasource.changePassword(
        token: token,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      return Right(success);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to change password',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearLocalProfile() async {
    try {
      await _localDatasource.deleteProfile();
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
