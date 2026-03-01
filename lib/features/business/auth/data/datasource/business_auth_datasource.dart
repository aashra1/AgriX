import 'package:agrix/features/business/auth/data/models/business_auth_api_model.dart';
import 'package:agrix/features/business/auth/data/models/business_auth_hive_model.dart';

abstract class IBusinessAuthLocalDatasource {
  Future<bool> registerBusiness(BusinessAuthHiveModel model);
  Future<BusinessAuthHiveModel?> loginBusiness(String email, String password);

  Future<BusinessAuthHiveModel?> updateBusinessDocument({
    required String businessId,
    required String documentPath,
  });
}

abstract interface class IBusinessAuthRemoteDatasource {
  Future<Map<String, dynamic>> registerBusiness(BusinessAuthApiModel model);
  Future<BusinessAuthApiModel?> loginBusiness(String email, String password);

  Future<BusinessAuthApiModel> uploadBusinessDocument({
    required String businessId,
    required String documentPath,
    required String token,
  });
}
