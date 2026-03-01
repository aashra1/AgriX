import 'package:agrix/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthDatasource {
  Future<bool> registerUser(AuthHiveModel model);
  Future<AuthHiveModel?> loginUser(String email, String password);
}
