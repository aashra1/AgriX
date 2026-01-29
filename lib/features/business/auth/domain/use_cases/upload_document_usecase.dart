import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/usecases/app_usecases.dart';
import 'package:agrix/features/business/auth/data/repositories/business_auth_repository.dart';
import 'package:agrix/features/business/auth/domain/entities/business_auth_entity.dart';
import 'package:agrix/features/business/auth/domain/repository/business_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadDocumentUsecaseParams extends Equatable {
  final String businessId;
  final String documentPath;
  final String token;

  const UploadDocumentUsecaseParams({
    required this.businessId,
    required this.documentPath,
    required this.token,
  });

  @override
  List<Object?> get props => [businessId, documentPath, token];
}

final uploadDocumentUsecaseProvider = Provider<UploadDocumentUsecase>((ref) {
  final authRepository = ref.read(businessAuthRepositoryProvider);
  return UploadDocumentUsecase(authRepository: authRepository);
});

class UploadDocumentUsecase
    implements
        UsecaseWithParams<BusinessAuthEntity, UploadDocumentUsecaseParams> {
  final IBusinessAuthRepository _authRepository;

  UploadDocumentUsecase({required IBusinessAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, BusinessAuthEntity>> call(
    UploadDocumentUsecaseParams params,
  ) {
    return _authRepository.uploadBusinessDocument(
      businessId: params.businessId,
      documentPath: params.documentPath,
      token: params.token,
    );
  }
}
