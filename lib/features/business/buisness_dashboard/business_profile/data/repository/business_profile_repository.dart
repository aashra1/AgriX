import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/business/buisness_dashboard/business_profile/data/datasource/business_profile_datasource.dart';
import 'package:agrix/features/business/buisness_dashboard/business_profile/domain/entity/business_profile_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/business_profile/domain/repository/business_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessProfileRepositoryProvider = Provider<IBusinessProfileRepository>((
  ref,
) {
  final remoteDatasource = ref.read(businessProfileRemoteDatasourceProvider);
  return BusinessProfileRepository(remoteDatasource: remoteDatasource);
});

class BusinessProfileRepository implements IBusinessProfileRepository {
  final IBusinessProfileRemoteDatasource _remoteDatasource;

  BusinessProfileRepository({
    required IBusinessProfileRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, BusinessProfileEntity>> getBusinessProfile({
    required String token,
  }) async {
    try {
      final apiModel = await _remoteDatasource.getBusinessProfile(token: token);
      return Right(apiModel.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? 'Failed to fetch business profile',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BusinessProfileEntity>> updateBusinessProfile({
    required String token,
    String? businessName,
    String? email,
    String? phoneNumber,
    String? address,
    String? imagePath,
  }) async {
    try {
      final profileData = <String, dynamic>{};
      if (businessName != null && businessName.isNotEmpty) {
        profileData['businessName'] = businessName;
      }
      if (email != null && email.isNotEmpty) {
        profileData['email'] = email;
      }
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        profileData['phoneNumber'] = phoneNumber;
      }
      if (address != null && address.isNotEmpty) {
        profileData['address'] = address;
      }

      final apiModel = await _remoteDatasource.updateBusinessProfile(
        token: token,
        profileData: profileData,
        imagePath: imagePath,
      );

      return Right(apiModel.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ??
              'Failed to update business profile',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
