import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/usecases/app_usecases.dart';
import 'package:agrix/features/business/buisness_dashboard/business_profile/data/repository/business_profile_repository.dart';
import 'package:agrix/features/business/buisness_dashboard/business_profile/domain/entity/business_profile_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/business_profile/domain/repository/business_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getBusinessProfileUsecaseProvider = Provider<GetBusinessProfileUsecase>((
  ref,
) {
  final repository = ref.read(businessProfileRepositoryProvider);
  return GetBusinessProfileUsecase(repository: repository);
});

final updateBusinessProfileUsecaseProvider =
    Provider<UpdateBusinessProfileUsecase>((ref) {
      final repository = ref.read(businessProfileRepositoryProvider);
      return UpdateBusinessProfileUsecase(repository: repository);
    });

class GetBusinessProfileUsecaseParams extends Equatable {
  final String token;
  const GetBusinessProfileUsecaseParams({required this.token});

  @override
  List<Object?> get props => [token];
}

class GetBusinessProfileUsecase
    implements
        UsecaseWithParams<
          BusinessProfileEntity,
          GetBusinessProfileUsecaseParams
        > {
  final IBusinessProfileRepository _repository;

  GetBusinessProfileUsecase({required IBusinessProfileRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, BusinessProfileEntity>> call(
    GetBusinessProfileUsecaseParams params,
  ) {
    return _repository.getBusinessProfile(token: params.token);
  }
}

class UpdateBusinessProfileUsecaseParams extends Equatable {
  final String token;
  final String? businessName;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? imagePath;

  const UpdateBusinessProfileUsecaseParams({
    required this.token,
    this.businessName,
    this.email,
    this.phoneNumber,
    this.address,
    this.imagePath,
  });

  @override
  List<Object?> get props => [
    token,
    businessName,
    email,
    phoneNumber,
    address,
    imagePath,
  ];
}

class UpdateBusinessProfileUsecase
    implements
        UsecaseWithParams<
          BusinessProfileEntity,
          UpdateBusinessProfileUsecaseParams
        > {
  final IBusinessProfileRepository _repository;

  UpdateBusinessProfileUsecase({required IBusinessProfileRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, BusinessProfileEntity>> call(
    UpdateBusinessProfileUsecaseParams params,
  ) {
    return _repository.updateBusinessProfile(
      token: params.token,
      businessName: params.businessName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      address: params.address,
      imagePath: params.imagePath,
    );
  }
}
