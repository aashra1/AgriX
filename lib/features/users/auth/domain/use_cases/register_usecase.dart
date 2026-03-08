import 'package:agrix/core/usecases/app_usecases.dart';
import 'package:agrix/features/users/auth/data/repositories/auth_repository.dart';
import 'package:agrix/features/users/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/error/failure.dart';
import '../entities/auth_entity.dart';

class RegisterUsecaseParams extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String? phoneNumber;
  final String? address;
  final String? imagePath;

  const RegisterUsecaseParams({
    required this.fullName,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.address,
    this.imagePath,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    password,
    phoneNumber,
    address,
    imagePath,
  ];
}

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final authEntity = AuthEntity(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
      phoneNumber: params.phoneNumber,
      address: params.address,
    );

    return _authRepository.registerUser(
      authEntity,
      imagePath: params.imagePath,
    );
  }
}
