import 'package:agrix/core/api/api_client.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/features/users/cart/data/datasource/cart_datasource.dart';
import 'package:agrix/features/users/cart/data/model/cart_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartRemoteDatasourceProvider = Provider<ICartRemoteDatasource>((ref) {
  return CartRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class CartRemoteDatasource implements ICartRemoteDatasource {
  final ApiClient _apiClient;

  CartRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<CartApiModel> getCart({required String token}) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.get(
        ApiEndpoints.cart,
        options: options,
      );

      if (response.data['success'] == true) {
        return CartApiModel.fromJson(response.data);
      }

      throw Exception('Failed to fetch cart: ${response.data['message']}');
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch cart: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<CartApiModel> addToCart({
    required String token,
    required String productId,
    required int quantity,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final data = {'productId': productId, 'quantity': quantity};

      final response = await _apiClient.post(
        ApiEndpoints.addToCart,
        data: data,
        options: options,
      );

      if (response.data['success'] == true) {
        return CartApiModel.fromJson(response.data);
      }

      throw Exception('Failed to add to cart: ${response.data['message']}');
    } on DioException catch (e) {
      throw Exception(
        'Failed to add to cart: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<CartApiModel> updateCartItem({
    required String token,
    required String productId,
    required int quantity,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final data = {'quantity': quantity};

      final response = await _apiClient.put(
        ApiEndpoints.updateCartItem(productId),
        data: data,
        options: options,
      );

      if (response.data['success'] == true) {
        return CartApiModel.fromJson(response.data);
      }

      throw Exception('Failed to update cart: ${response.data['message']}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Item not found in cart');
      }
      throw Exception(
        'Failed to update cart: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<CartApiModel> removeFromCart({
    required String token,
    required String productId,
  }) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.delete(
        ApiEndpoints.removeFromCart(productId),
        options: options,
      );

      if (response.data['success'] == true) {
        return CartApiModel.fromJson(response.data);
      }

      throw Exception(
        'Failed to remove from cart: ${response.data['message']}',
      );
    } on DioException catch (e) {
      throw Exception(
        'Failed to remove from cart: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<CartApiModel> clearCart({required String token}) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.delete(
        ApiEndpoints.clearCart,
        options: options,
      );

      if (response.data['success'] == true) {
        return CartApiModel.fromJson(response.data);
      }

      throw Exception('Failed to clear cart: ${response.data['message']}');
    } on DioException catch (e) {
      throw Exception(
        'Failed to clear cart: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<int> getCartCount({required String token}) async {
    try {
      final options = Options(headers: {'Authorization': 'Bearer $token'});

      final response = await _apiClient.get(
        ApiEndpoints.cartCount,
        options: options,
      );

      if (response.data['success'] == true) {
        return response.data['count'] as int? ?? 0;
      }

      throw Exception('Failed to get cart count: ${response.data['message']}');
    } on DioException catch (e) {
      throw Exception(
        'Failed to get cart count: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }
}
