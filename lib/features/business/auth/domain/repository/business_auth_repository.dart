import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/business/auth/domain/entities/business_auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IBusinessAuthRepository {
  Future<Either<Failure, BusinessAuthEntity>> loginBusiness(
    String email,
    String password,
  );

  Future<Either<Failure, Map<String, dynamic>>> registerBusiness(
    BusinessAuthEntity entity,
  );

  Future<Either<Failure, BusinessAuthEntity>> uploadBusinessDocument({
    required String businessId,
    required String documentPath,
    required String token,
  });
}
