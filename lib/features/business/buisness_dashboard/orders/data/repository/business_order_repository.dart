import 'package:agrix/core/error/failure.dart';
import 'package:agrix/core/services/connectivity/network_infor.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/data/datasource/business_order_datasource.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/data/datasource/local/business_orders_local_datasource.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/data/datasource/remote/business_orders_remote_datasource.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/data/model/business_order_hive_model.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/data/model/business_order_model.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/domain/entity/business_order_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/domain/repository/business_order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessOrderRepositoryProvider = Provider<IBusinessOrderRepository>((
  ref,
) {
  final localDatasource = ref.read(businessOrderLocalDatasourceProvider);
  final remoteDatasource = ref.read(businessOrderRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return BusinessOrderRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class BusinessOrderRepository implements IBusinessOrderRepository {
  final IBusinessOrderLocalDatasource _localDatasource;
  final IBusinessOrderRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  BusinessOrderRepository({
    required IBusinessOrderLocalDatasource localDatasource,
    required IBusinessOrderRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _localDatasource = localDatasource,
       _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<BusinessOrderEntity>>> getBusinessOrders({
    required String token,
    required String businessId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected == true) {
        final apiOrders = await _remoteDatasource.getBusinessOrders(
          token: token,
          page: page,
          limit: limit,
        );

        // Sync with local database
        await _localDatasource.syncOrders(businessId, apiOrders);

        final entities = BusinessOrderApiModel.toEntityList(apiOrders);
        return Right(entities);
      } else {
        // Offline: Get from local database
        final localOrders = await _localDatasource.getBusinessOrders(
          businessId,
        );
        final entities = BusinessOrderHiveModel.toEntityList(localOrders);
        return Right(entities);
      }
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? 'Failed to fetch business orders',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      if (e.toString().contains('LocalDatabaseFailure') ||
          e.toString().contains('Hive') ||
          e.toString().contains('local')) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BusinessOrderEntity>> getOrderById({
    required String orderId,
    required String token,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected == true) {
        final apiModel = await _remoteDatasource.getOrderById(
          orderId: orderId,
          token: token,
        );

        // Update local database
        final hiveModel = BusinessOrderHiveModel.fromEntity(
          apiModel.toEntity(),
        );
        await _localDatasource.updateOrder(hiveModel);

        return Right(apiModel.toEntity());
      } else {
        // Offline: Get from local database
        final localOrder = await _localDatasource.getOrderById(orderId);
        if (localOrder != null) {
          return Right(localOrder.toEntity());
        }
        return Left(LocalDatabaseFailure(message: 'Order not found locally'));
      }
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch order',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      if (e.toString().contains('LocalDatabaseFailure') ||
          e.toString().contains('Hive') ||
          e.toString().contains('local')) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BusinessOrderEntity>> updateOrderStatus({
    required String orderId,
    required String orderStatus,
    String? trackingNumber,
    required String token,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected == true) {
        // Online: Update via API
        final apiModel = await _remoteDatasource.updateOrderStatus(
          orderId: orderId,
          orderStatus: orderStatus,
          trackingNumber: trackingNumber,
          token: token,
        );

        // Update local database
        final hiveModel = BusinessOrderHiveModel.fromEntity(
          apiModel.toEntity(),
        );
        await _localDatasource.updateOrder(hiveModel);

        return Right(apiModel.toEntity());
      } else {
        // Offline: Update locally only
        final existingOrder = await _localDatasource.getOrderById(orderId);
        if (existingOrder == null) {
          return Left(LocalDatabaseFailure(message: 'Order not found'));
        }

        final updatedModel = BusinessOrderHiveModel(
          id: orderId,
          userId: existingOrder.userId,
          userFullName: existingOrder.userFullName,
          userEmail: existingOrder.userEmail,
          userPhone: existingOrder.userPhone,
          items: existingOrder.items,
          shippingAddress: existingOrder.shippingAddress,
          paymentMethod: existingOrder.paymentMethod,
          paymentStatus: existingOrder.paymentStatus,
          orderStatus: orderStatus,
          subtotal: existingOrder.subtotal,
          shipping: existingOrder.shipping,
          tax: existingOrder.tax,
          total: existingOrder.total,
          trackingNumber: trackingNumber ?? existingOrder.trackingNumber,
          notes: existingOrder.notes,
          createdAt: existingOrder.createdAt,
          updatedAt: DateTime.now(),
        );

        await _localDatasource.updateOrder(updatedModel);
        return Right(updatedModel.toEntity());
      }
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? 'Failed to update order status',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      if (e.toString().contains('LocalDatabaseFailure') ||
          e.toString().contains('Hive') ||
          e.toString().contains('local')) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BusinessOrderEntity>> updatePaymentStatus({
    required String orderId,
    required String paymentStatus,
    required String token,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (isConnected == true) {
        // Online: Update via API
        final apiModel = await _remoteDatasource.updatePaymentStatus(
          orderId: orderId,
          paymentStatus: paymentStatus,
          token: token,
        );

        // Update local database
        final hiveModel = BusinessOrderHiveModel.fromEntity(
          apiModel.toEntity(),
        );
        await _localDatasource.updateOrder(hiveModel);

        return Right(apiModel.toEntity());
      } else {
        // Offline: Update locally only
        final existingOrder = await _localDatasource.getOrderById(orderId);
        if (existingOrder == null) {
          return Left(LocalDatabaseFailure(message: 'Order not found'));
        }

        final updatedModel = BusinessOrderHiveModel(
          id: orderId,
          userId: existingOrder.userId,
          userFullName: existingOrder.userFullName,
          userEmail: existingOrder.userEmail,
          userPhone: existingOrder.userPhone,
          items: existingOrder.items,
          shippingAddress: existingOrder.shippingAddress,
          paymentMethod: existingOrder.paymentMethod,
          paymentStatus: paymentStatus,
          orderStatus: existingOrder.orderStatus,
          subtotal: existingOrder.subtotal,
          shipping: existingOrder.shipping,
          tax: existingOrder.tax,
          total: existingOrder.total,
          trackingNumber: existingOrder.trackingNumber,
          notes: existingOrder.notes,
          createdAt: existingOrder.createdAt,
          updatedAt: DateTime.now(),
        );

        await _localDatasource.updateOrder(updatedModel);
        return Right(updatedModel.toEntity());
      }
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? 'Failed to update payment status',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      if (e.toString().contains('LocalDatabaseFailure') ||
          e.toString().contains('Hive') ||
          e.toString().contains('local')) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
