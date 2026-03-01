import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/services/connectivity/network_infor.dart';
import 'package:agrix/features/users/order/data/datasource/local/user_order_local_datasource.dart';
import 'package:agrix/features/users/order/data/datasource/remote/user_order_remote_datasource.dart';
import 'package:agrix/features/users/order/data/datasource/user_order_datasource.dart';
import 'package:agrix/features/users/order/data/model/user_order_api_model.dart';
import 'package:agrix/features/users/order/data/model/user_order_hive_model.dart';
import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:agrix/features/users/order/domain/repository/user_order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userOrderRepositoryProvider = Provider<IUserOrderRepository>((ref) {
  final localDatasource = ref.read(userOrderLocalDatasourceProvider);
  final remoteDatasource = ref.read(userOrderRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return UserOrderRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class UserOrderRepository implements IUserOrderRepository {
  final IUserOrderLocalDatasource _localDatasource;
  final IUserOrderRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  UserOrderRepository({
    required IUserOrderLocalDatasource localDatasource,
    required IUserOrderRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _localDatasource = localDatasource,
       _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, UserOrderEntity>> createOrder({
    required String token,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected != true) {
        return Left(
          LocalDatabaseFailure(message: 'Cannot create order while offline'),
        );
      }

      final apiOrder = await _remoteDatasource.createOrder(
        token: token,
        orderData: orderData,
      );

      final hiveModel = UserOrderHiveModel.fromEntity(apiOrder.toEntity());
      await _localDatasource.addOrder(hiveModel);

      return Right(apiOrder.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to create order',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserOrderEntity>>> getUserOrders({
    required String token,
    int page = 1,
    int limit = 10,
    bool refresh = false,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected == true) {
        final apiOrders = await _remoteDatasource.getUserOrders(
          token: token,
          page: page,
          limit: limit,
        );

        if (apiOrders.isNotEmpty && (refresh || page == 1)) {
          final userId = apiOrders.first.user;
          await _localDatasource.syncOrders(userId, apiOrders);
        }

        final entities = UserOrderApiModel.toEntityList(apiOrders);
        return Right(entities);
      } else {
        final userId = ''; // Get from session
        final localOrders = await _localDatasource.getUserOrders(userId);
        final entities = UserOrderHiveModel.toEntityList(localOrders);
        return Right(entities);
      }
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch orders',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserOrderEntity>> getOrderById({
    required String token,
    required String orderId,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected == true) {
        final apiOrder = await _remoteDatasource.getOrderById(
          token: token,
          orderId: orderId,
        );

        final hiveModel = UserOrderHiveModel.fromEntity(apiOrder.toEntity());
        await _localDatasource.addOrder(hiveModel);

        return Right(apiOrder.toEntity());
      } else {
        final localOrder = await _localDatasource.getOrderById(orderId);
        if (localOrder != null) {
          return Right(localOrder.toEntity());
        }
        return Left(LocalDatabaseFailure(message: 'Order not found locally'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return Left(ApiFailure(message: 'Order not found', statusCode: 404));
      }
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch order',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
