import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/business/buisness_dashboard/business_profile/domain/entity/business_profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IBusinessProfileRepository {
  Future<Either<Failure, BusinessProfileEntity>> getBusinessProfile({
    required String token,
  });

  Future<Either<Failure, BusinessProfileEntity>> updateBusinessProfile({
    required String token,
    String? businessName,
    String? email,
    String? phoneNumber,
    String? address,
    String? imagePath,
  });
}
