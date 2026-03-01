import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/usecases/app_usecases.dart';
import 'package:agrix/features/business/auth/data/repositories/business_auth_repository.dart';
import 'package:agrix/features/business/auth/domain/entities/business_auth_entity.dart';
import 'package:agrix/features/business/auth/domain/repository/business_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessLoginUsecaseParams extends Equatable {
  final String email;
  final String password;

  const BusinessLoginUsecaseParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

// Provider for Business Login Usecase
final businessLoginUsecaseProvider = Provider<BusinessLoginUsecase>((ref) {
  final authRepository = ref.read(businessAuthRepositoryProvider);
  return BusinessLoginUsecase(authRepository: authRepository);
});

class BusinessLoginUsecase
    implements UsecaseWithParams<BusinessAuthEntity, BusinessLoginUsecaseParams> {
  final IBusinessAuthRepository _authRepository;

  BusinessLoginUsecase({required IBusinessAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, BusinessAuthEntity>> call(
    BusinessLoginUsecaseParams params,
  ) {
    return _authRepository.loginBusiness(params.email, params.password);
  }
}