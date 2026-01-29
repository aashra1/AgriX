import 'package:agrix/features/users/auth/data/models/auth_api_model.dart';
import 'package:agrix/features/users/auth/data/models/auth_hive_model.dart';

abstract class IAuthLocalDatasource {
  Future<bool> registerUser(AuthHiveModel model);
  Future<AuthHiveModel?> loginUser(String email, String password);
}

abstract interface class IAuthRemoteDatasource {
  Future<AuthApiModel> registerUser(AuthApiModel model);
  Future<AuthApiModel?> loginUser(String email, String password);
}
