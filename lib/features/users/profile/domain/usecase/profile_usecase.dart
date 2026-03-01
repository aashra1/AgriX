import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/usecases/app_usecases.dart';
import 'package:agrix/features/users/profile/data/repository/profile_remote_repository.dart';
import 'package:agrix/features/users/profile/domain/entity/profile_entity.dart';
import 'package:agrix/features/users/profile/domain/repository/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserProfileUsecaseProvider = Provider<GetUserProfileUsecase>((ref) {
  final repository = ref.read(userProfileRepositoryProvider);
  return GetUserProfileUsecase(repository: repository);
});

final updateUserProfileUsecaseProvider = Provider<UpdateUserProfileUsecase>((
  ref,
) {
  final repository = ref.read(userProfileRepositoryProvider);
  return UpdateUserProfileUsecase(repository: repository);
});

final changePasswordUsecaseProvider = Provider<ChangePasswordUsecase>((ref) {
  final repository = ref.read(userProfileRepositoryProvider);
  return ChangePasswordUsecase(repository: repository);
});

final clearLocalProfileUsecaseProvider = Provider<ClearLocalProfileUsecase>((
  ref,
) {
  final repository = ref.read(userProfileRepositoryProvider);
  return ClearLocalProfileUsecase(repository: repository);
});

class GetUserProfileUsecaseParams extends Equatable {
  final String token;
  const GetUserProfileUsecaseParams({required this.token});

  @override
  List<Object?> get props => [token];
}

class GetUserProfileUsecase
    implements
        UsecaseWithParams<UserProfileEntity, GetUserProfileUsecaseParams> {
  final IUserProfileRepository _repository;

  GetUserProfileUsecase({required IUserProfileRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, UserProfileEntity>> call(
    GetUserProfileUsecaseParams params,
  ) {
    return _repository.getUserProfile(token: params.token);
  }
}

class UpdateUserProfileUsecaseParams extends Equatable {
  final String token;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? imagePath;

  const UpdateUserProfileUsecaseParams({
    required this.token,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.address,
    this.imagePath,
  });

  @override
  List<Object?> get props => [
    token,
    fullName,
    email,
    phoneNumber,
    address,
    imagePath,
  ];
}

class UpdateUserProfileUsecase
    implements
        UsecaseWithParams<UserProfileEntity, UpdateUserProfileUsecaseParams> {
  final IUserProfileRepository _repository;

  UpdateUserProfileUsecase({required IUserProfileRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, UserProfileEntity>> call(
    UpdateUserProfileUsecaseParams params,
  ) {
    return _repository.updateUserProfile(
      token: params.token,
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      address: params.address,
      imagePath: params.imagePath,
    );
  }
}

class ChangePasswordUsecaseParams extends Equatable {
  final String token;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordUsecaseParams({
    required this.token,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [
    token,
    currentPassword,
    newPassword,
    confirmPassword,
  ];
}

class ChangePasswordUsecase
    implements UsecaseWithParams<bool, ChangePasswordUsecaseParams> {
  final IUserProfileRepository _repository;

  ChangePasswordUsecase({required IUserProfileRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(ChangePasswordUsecaseParams params) {
    return _repository.changePassword(
      token: params.token,
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
      confirmPassword: params.confirmPassword,
    );
  }
}

class ClearLocalProfileUsecase implements UsecaseWithoutParams<void> {
  final IUserProfileRepository _repository;

  ClearLocalProfileUsecase({required IUserProfileRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call() {
    return _repository.clearLocalProfile();
  }
}
