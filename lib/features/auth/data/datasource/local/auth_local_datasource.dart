import 'package:agrix/core/services/hive/hive_service.dart';
import 'package:agrix/features/auth/data/datasource/auth_datasource.dart';
import 'package:agrix/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);

  return AuthLocalDatasource(hiveService: hiveService);
});

class AuthLocalDatasource implements IAuthDatasource {
  final HiveService _hiveService;

  AuthLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> registerUser(AuthHiveModel model) async {
    try {
      await _hiveService.register(model);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    try {
      return _hiveService.login(email, password);
    } catch (_) {
      return null;
    }
  }
}
