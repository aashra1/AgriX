import 'package:agrix/core/constants/hive_table_constant.dart';
import 'package:agrix/features/business/auth/data/models/business_auth_hive_model.dart';
import 'package:agrix/features/business/buisness_dashboard/orders/data/model/business_order_hive_model.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/model/business_product_hive_model.dart';
import 'package:agrix/features/users/auth/data/models/auth_hive_model.dart';
import 'package:agrix/features/users/product/data/model/user_product_hive_model.dart';
import 'package:agrix/features/users/profile/data/model/profile_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // init
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);

    // register adapter
    _registerAdapter();
    await _openBoxes();
  }

  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.businessAuthTypeId)) {
      Hive.registerAdapter(BusinessAuthHiveModelAdapter());
    }

    // Register user profile adapter
    if (!Hive.isAdapterRegistered(HiveTableConstant.userProfileTypeId)) {
      Hive.registerAdapter(UserProfileHiveModelAdapter());
    }
  }

  // box open
  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    await Hive.openBox<BusinessAuthHiveModel>(
      HiveTableConstant.businessAuthTable,
    );
    await Hive.openBox<UserProfileHiveModel>(
      HiveTableConstant.userProfileTable,
    );
    await Hive.openBox<ProductHiveModel>(HiveTableConstant.productTable);
    await Hive.openBox<BusinessOrderHiveModel>(
      HiveTableConstant.businessOrderTable,
    );
  }

  // box close
  Future<void> _close() async {
    await Hive.close();
  }

  // ======================= Auth Queries =========================

  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  // Register user
  Future<AuthHiveModel> register(AuthHiveModel user) async {
    await _authBox.put(user.authId, user);
    return user;
  }

  // Login - find user by email and password
  AuthHiveModel? login(String email, String password) {
    try {
      return _authBox.values.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // ======================= Business Auth Queries =========================

  Box<BusinessAuthHiveModel> get _businessAuthBox =>
      Hive.box<BusinessAuthHiveModel>(HiveTableConstant.businessAuthTable);

  // Register business
  Future<BusinessAuthHiveModel> registerBusiness(
    BusinessAuthHiveModel business,
  ) async {
    await _businessAuthBox.put(business.businessId, business);
    return business;
  }

  // Login business - find business by email and password
  BusinessAuthHiveModel? loginBusiness(String email, String password) {
    try {
      return _businessAuthBox.values.firstWhere(
        (business) => business.email == email && business.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // Get business by ID
  BusinessAuthHiveModel? getBusinessById(String businessId) {
    try {
      return _businessAuthBox.get(businessId);
    } catch (e) {
      return null;
    }
  }

  // Get all businesses (for offline viewing if needed)
  List<BusinessAuthHiveModel> getAllBusinesses() {
    return _businessAuthBox.values.toList();
  }

  // Update business document path
  Future<BusinessAuthHiveModel?> updateBusinessDocument(
    String businessId,
    String documentPath,
  ) async {
    try {
      final business = _businessAuthBox.get(businessId);
      if (business != null) {
        final updatedBusiness = BusinessAuthHiveModel(
          businessId: business.businessId,
          businessName: business.businessName,
          email: business.email,
          password: business.password,
          phoneNumber: business.phoneNumber,
          address: business.address,
          businessDocument: documentPath,
          businessStatus: 'Pending',
          businessVerified: false,
        );
        await _businessAuthBox.put(businessId, updatedBusiness);
        return updatedBusiness;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Update business status (for offline sync)
  Future<BusinessAuthHiveModel?> updateBusinessStatus(
    String businessId,
    String status,
    bool verified,
  ) async {
    try {
      final business = _businessAuthBox.get(businessId);
      if (business != null) {
        final updatedBusiness = BusinessAuthHiveModel(
          businessId: business.businessId,
          businessName: business.businessName,
          email: business.email,
          password: business.password,
          phoneNumber: business.phoneNumber,
          address: business.address,
          businessDocument: business.businessDocument,
          businessStatus: status,
          businessVerified: verified,
        );
        await _businessAuthBox.put(businessId, updatedBusiness);
        return updatedBusiness;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Check if business exists by email
  bool businessExists(String email) {
    try {
      return _businessAuthBox.values.any((business) => business.email == email);
    } catch (e) {
      return false;
    }
  }

  // Clear all business data
  Future<void> clearAllBusinesses() async {
    await _businessAuthBox.clear();
  }

  // Delete specific business
  Future<void> deleteBusiness(String businessId) async {
    await _businessAuthBox.delete(businessId);
  }

  // Get businesses by status
  List<BusinessAuthHiveModel> getBusinessesByStatus(String status) {
    try {
      return _businessAuthBox.values
          .where((business) => business.businessStatus == status)
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ======================= User Profile Queries =========================

  Box<UserProfileHiveModel> get _userProfileBox =>
      Hive.box<UserProfileHiveModel>(HiveTableConstant.userProfileTable);

  Future<void> saveUserProfile(UserProfileHiveModel profile) async {
    await _userProfileBox.put('currentUser', profile);
  }

  Future<UserProfileHiveModel?> getUserProfile() async {
    try {
      return _userProfileBox.get('currentUser');
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserProfile(UserProfileHiveModel profile) async {
    await _userProfileBox.put('currentUser', profile);
  }

  Future<void> deleteUserProfile() async {
    await _userProfileBox.delete('currentUser');
  }

  Future<void> clearUserProfiles() async {
    await _userProfileBox.clear();
  }

  // ======================= Product Queries =========================

  Box<ProductHiveModel> get _productBox =>
      Hive.box<ProductHiveModel>(HiveTableConstant.productTable);

  Future<void> addProduct(ProductHiveModel product) async {
    await _productBox.put(product.productId, product);
  }

  List<ProductHiveModel> getBusinessProducts(String businessId) {
    try {
      return _productBox.values
          .where((product) => product.businessId == businessId)
          .toList();
    } catch (e) {
      return [];
    }
  }

  ProductHiveModel? getProductById(String productId) {
    try {
      return _productBox.get(productId);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateProduct(ProductHiveModel product) async {
    await _productBox.put(product.productId, product);
  }

  Future<void> deleteProduct(String productId) async {
    await _productBox.delete(productId);
  }

  Future<void> clearBusinessProducts(String businessId) async {
    final products = getBusinessProducts(businessId);
    for (final product in products) {
      await _productBox.delete(product.productId);
    }
  }

  // ======================= Business Order Queries =========================

  Box<BusinessOrderHiveModel> get _businessOrderBox =>
      Hive.box<BusinessOrderHiveModel>(HiveTableConstant.businessOrderTable);

  Future<void> addBusinessOrder(BusinessOrderHiveModel order) async {
    await _businessOrderBox.put(order.id, order);
  }

  Future<List<BusinessOrderHiveModel>> getBusinessOrders(
    String businessId,
  ) async {
    return _businessOrderBox.values.where((order) {
      return order.items.any((item) => item.businessId == businessId);
    }).toList();
  }

  Future<BusinessOrderHiveModel?> getBusinessOrderById(String orderId) async {
    return _businessOrderBox.get(orderId);
  }

  Future<void> updateBusinessOrder(BusinessOrderHiveModel order) async {
    await _businessOrderBox.put(order.id, order);
  }

  Future<void> deleteBusinessOrder(String orderId) async {
    await _businessOrderBox.delete(orderId);
  }

  Future<void> clearBusinessOrders(String businessId) async {
    final ordersToDelete =
        _businessOrderBox.values
            .where(
              (order) =>
                  order.items.any((item) => item.businessId == businessId),
            )
            .map((order) => order.id)
            .toList();

    for (final id in ordersToDelete) {
      await _businessOrderBox.delete(id);
    }
  }

  Box<UserProductHiveModel> get _userProductBox =>
      Hive.box<UserProductHiveModel>(HiveTableConstant.userProductTable);

  Future<void> addUserProduct(UserProductHiveModel product) async {
    await _userProductBox.put(product.productId, product);
  }

  List<UserProductHiveModel> getAllUserProducts() {
    try {
      return _userProductBox.values.toList();
    } catch (e) {
      return [];
    }
  }

  List<UserProductHiveModel> getUserProductsByCategory(String categoryId) {
    try {
      return _userProductBox.values
          .where((product) => product.categoryId == categoryId)
          .toList();
    } catch (e) {
      return [];
    }
  }

  UserProductHiveModel? getUserProductById(String productId) {
    try {
      return _userProductBox.get(productId);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserProduct(UserProductHiveModel product) async {
    await _userProductBox.put(product.productId, product);
  }

  Future<void> deleteUserProduct(String productId) async {
    await _userProductBox.delete(productId);
  }

  Future<void> clearAllUserProducts() async {
    await _userProductBox.clear();
  }
}
