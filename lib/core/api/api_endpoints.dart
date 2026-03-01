class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change this for production
  // static const String baseUrl = 'http://192.168.68.106:5001/api';
  static const String baseIp = 'http://192.168.68.127:5001';
  static const String baseUrl = '$baseIp/api';

  //static const String baseUrl = 'http://localhost:3000/api/v1';

  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For iOS Simulator use: 'http://localhost:5000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api/v1'

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String users = '/user';
  static const String userLogin = '/user/login';
  static const String userRegister = '/user/register';

  // Dynamic endpoints with parameters
  static String userById(String id) => '/user/$id';
  static String editUserProfile(String id) => '/user/$id';
  static String deleteUserAccount(String id) => '/user/$id';

  // ============ Business Endpoints =============
  static const String business = '/business';
  static const String businessRegister = '/business/register';
  static const String businessLogin = '/business/login';
  static const String businessUploadDocument = '/business/upload-document';
  static const String businessAdminApprove = '/business/admin/approve';
  static const String businessAdminAll = '/business/admin/all';

  static String businessApproveById(String businessId) =>
      '/business/admin/approve/$businessId';

  // ============ Category Endpoints =============
  static const String categories = '/categories';
  static String categoryById(String id) => '/categories/$id';

  static const String products = '/product';
  static const String businessProducts = '/product/business';
  static String productById(String id) => '/product/$id';
  static const String imageUrl = '$baseIp/uploads/product-images';

  // ============ Dashboard Endpoints =============
  static const String dashboard = '/dashboard';
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardAnalytics = '/dashboard/analytics';
}
