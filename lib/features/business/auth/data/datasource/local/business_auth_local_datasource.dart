import 'package:agrix/core/services/hive/hive_service.dart';
import 'package:agrix/features/business/auth/data/datasource/business_auth_datasource.dart';
import 'package:agrix/features/business/auth/data/models/business_auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessAuthLocalDatasourceProvider =
    Provider<BusinessAuthLocalDatasource>((ref) {
      final hiveService = ref.read(hiveServiceProvider);
      return BusinessAuthLocalDatasource(hiveService: hiveService);
    });

class BusinessAuthLocalDatasource implements IBusinessAuthLocalDatasource {
  final HiveService _hiveService;

  BusinessAuthLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> registerBusiness(BusinessAuthHiveModel model) async {
    try {
      await _hiveService.registerBusiness(model);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<BusinessAuthHiveModel?> loginBusiness(
    String email,
    String password,
  ) async {
    try {
      return _hiveService.loginBusiness(email, password);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<BusinessAuthHiveModel?> updateBusinessDocument({
    required String businessId,
    required String documentPath,
  }) async {
    try {
      return await _hiveService.updateBusinessDocument(
        businessId,
        documentPath,
      );
    } catch (e) {
      return null;
    }
  }
}
