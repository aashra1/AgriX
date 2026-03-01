import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/users/payment/data/datasource/remote/user_payment_remote_datasource.dart';
import 'package:agrix/features/users/payment/data/datasource/user_payment_datasource.dart';
import 'package:agrix/features/users/payment/data/model/user_payment_model.dart';
import 'package:agrix/features/users/payment/domain/entity/user_payment_entity.dart';
import 'package:agrix/features/users/payment/domain/repository/user_payment_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userPaymentRepositoryProvider = Provider<IUserPaymentRepository>((ref) {
  final remoteDatasource = ref.read(userPaymentRemoteDatasourceProvider);
  return UserPaymentRepository(remoteDatasource: remoteDatasource);
});

class UserPaymentRepository implements IUserPaymentRepository {
  final IUserPaymentRemoteDatasource _remoteDatasource;

  UserPaymentRepository({
    required IUserPaymentRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, InitiatePaymentEntity>> initiateKhaltiPayment({
    required String token,
    required String orderId,
    required double amount,
    required String returnUrl,
  }) async {
    try {
      final result = await _remoteDatasource.initiateKhaltiPayment(
        token: token,
        orderId: orderId,
        amount: amount,
        returnUrl: returnUrl,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to initiate payment',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserPaymentEntity>> verifyKhaltiPayment({
    required String token,
    required String pidx,
    required String orderId,
  }) async {
    try {
      final result = await _remoteDatasource.verifyKhaltiPayment(
        token: token,
        pidx: pidx,
        orderId: orderId,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to verify payment',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserPaymentEntity>> getPaymentByOrderId({
    required String token,
    required String orderId,
  }) async {
    try {
      final result = await _remoteDatasource.getPaymentByOrderId(
        token: token,
        orderId: orderId,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return Left(ApiFailure(message: 'Payment not found', statusCode: 404));
      }
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch payment',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserPaymentEntity>>> getUserPayments({
    required String token,
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final result = await _remoteDatasource.getUserPayments(
        token: token,
        page: page,
        limit: limit,
        status: status,
      );
      return Right(UserPaymentApiModel.toEntityList(result));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch payments',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
