import 'package:agrix/core/constants/hive_table_constant.dart';
import 'package:agrix/features/business/auth/data/models/business_auth_hive_model.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/model/business_product_hive_model.dart';
import 'package:agrix/features/users/auth/data/models/auth_hive_model.dart';
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
  }

  // box open
  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    await Hive.openBox<BusinessAuthHiveModel>(
      HiveTableConstant.businessAuthTable,
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

  Box<ProductHiveModel> get _productBox =>
      Hive.box<ProductHiveModel>('products');

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
}
