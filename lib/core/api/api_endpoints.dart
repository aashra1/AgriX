class ApiEndpoints {
  ApiEndpoints._();

  static const String baseIp = 'http://192.168.1.93:5001';
  static const String baseUrl = '$baseIp/api';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String users = '/user';
  static const String userLogin = '/user/login';
  static const String userRegister = '/user/register';
  static const String userProfile = '/user/profile';
  static const String editUserProfile = '/user/profile';
  static const String changePassword = '/user/change-password';
  static const String requestPasswordReset = '/user/request-password-reset';
  static String resetPassword(String token) => '/user/reset-password/$token';
  static String userById(String id) => '/user/$id';
  static String editUserById(String id) => '/user/$id';
  static String deleteUserAccount(String id) => '/user/$id';
  static const String getAllUsers = '/user';

  static const String business = '/business';
  static const String businessRegister = '/business/register';
  static const String businessLogin = '/business/login';
  static const String businessUploadDocument = '/business/upload-document';
  static const String businessAdminApprove = '/business/admin/approve';
  static const String businessAdminAll = '/business/admin/all';
  static const String businessProfile = '/business/profile';
  static const String editBusinessProfile = '/business/profile/edit';
  static String businessApproveById(String businessId) =>
      '/business/admin/approve/$businessId';

  static const String categories = '/categories';
  static String categoryById(String id) => '/categories/$id';

  static const String products = '/product';
  static const String businessProducts = '/product/business';
  static String productById(String id) => '/product/$id';
  static const String imageUrl = '$baseIp/uploads/product-images';

  static const String cart = '/cart';
  static const String addToCart = '/cart/add';
  static const String clearCart = '/cart/clear';
  static const String cartCount = '/cart/count';
  static String updateCartItem(String productId) => '/cart/item/$productId';
  static String removeFromCart(String productId) => '/cart/item/$productId';

  static const String orders = '/order';
  static const String userOrders = '/order/user';
  static const String businessOrders = '/order/business/orders';
  static String orderById(String orderId) => '/order/$orderId';
  static String updateOrderStatus(String orderId) => '/order/$orderId/status';
  static String updatePaymentStatus(String orderId) =>
      '/order/$orderId/payment';

  static const String initiateKhalti = '/payments/khalti/initiate';
  static const String verifyKhalti = '/payments/khalti/verify';
  static const String userPayments = '/payments/user';
  static const String allPaymentsAdmin = '/payments/admin/all';
  static String paymentByOrderId(String orderId) => '/payments/order/$orderId';

  static const String walletBalance = '/wallets/balance';
  static const String walletTransactions = '/wallets/transactions';
  static const String businessWalletBalance = '/wallets/business/balance';
  static const String businessWalletTransactions =
      '/wallets/business/transactions';

  static const String dashboard = '/dashboard';
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardAnalytics = '/dashboard/analytics';
}
