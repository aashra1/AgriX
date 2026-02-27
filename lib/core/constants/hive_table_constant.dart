class HiveTableConstant {
  HiveTableConstant._();

  static const String dbName = 'agrix_db';

  // Auth tables
  static const String authTable = 'auth';
  static const int authTypeId = 0;

  // Business Auth tables
  static const String businessAuthTable = 'businessAuth';
  static const int businessAuthTypeId = 1;

  // Product tables
  static const String productTable = 'products';
  static const int productTypeId = 2;

  // Business Order tables
  static const String businessOrderTable = 'businessOrders';
  static const int businessOrderTypeId = 3;

  // User Profile tables
  static const String userProfileTable = 'userProfile';
  static const int userProfileTypeId = 4;

  static const String userProductTable = 'userProducts';
  static const int userProductTypeId = 5;
}
