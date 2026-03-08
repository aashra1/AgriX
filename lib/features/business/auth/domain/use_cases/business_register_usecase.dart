import 'package:agrix/core/usecases/app_usecases.dart';
import 'package:agrix/features/business/auth/data/repositories/business_auth_repository.dart';
import 'package:agrix/features/business/auth/domain/entities/business_auth_entity.dart';
import 'package:agrix/features/business/auth/domain/repository/business_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/error/failure.dart';

class BusinessRegisterUsecaseParams extends Equatable {
  final String businessName;
  final String email;
  final String password;
  final String phoneNumber;
  final String? address;
  final String? imagePath;

  const BusinessRegisterUsecaseParams({
    required this.businessName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    this.address,
    this.imagePath,
  });

  @override
  List<Object?> get props => [
    businessName,
    email,
    password,
    phoneNumber,
    address,
    imagePath,
  ];
}

final businessRegisterUsecaseProvider = Provider<BusinessRegisterUsecase>((
  ref,
) {
  final authRepository = ref.read(businessAuthRepositoryProvider);
  return BusinessRegisterUsecase(authRepository: authRepository);
});

class BusinessRegisterUsecase
    implements
        UsecaseWithParams<Map<String, dynamic>, BusinessRegisterUsecaseParams> {
  final IBusinessAuthRepository _authRepository;

  BusinessRegisterUsecase({required IBusinessAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    BusinessRegisterUsecaseParams params,
  ) {
    final businessEntity = BusinessAuthEntity(
      businessName: params.businessName,
      email: params.email,
      password: params.password,
      phoneNumber: params.phoneNumber,
      address: params.address,
    );

    return _authRepository.registerBusiness(
      businessEntity,
      imagePath: params.imagePath,
    );
  }
}
