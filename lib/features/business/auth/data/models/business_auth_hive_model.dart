import 'package:agrix/features/business/auth/domain/entities/business_auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/constants/hive_table_constant.dart';

part 'business_auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.businessAuthTypeId)
class BusinessAuthHiveModel extends HiveObject {
  @HiveField(0)
  final String businessId;

  @HiveField(1)
  final String businessName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final String phoneNumber;

  @HiveField(5)
  final String? address;

  @HiveField(6)
  final String? businessDocument;

  @HiveField(7)
  final String? businessStatus;

  @HiveField(8)
  final bool? businessVerified;

  BusinessAuthHiveModel({
    String? businessId,
    required this.businessName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    this.address,
    this.businessDocument,
    this.businessStatus,
    this.businessVerified,
  }) : businessId = businessId ?? const Uuid().v4();

  BusinessAuthEntity toEntity() {
    return BusinessAuthEntity(
      businessId: businessId,
      businessName: businessName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      address: address,
      businessDocument: businessDocument,
      businessStatus: businessStatus,
      businessVerified: businessVerified,
    );
  }

  factory BusinessAuthHiveModel.fromEntity(BusinessAuthEntity entity) {
    return BusinessAuthHiveModel(
      businessId: entity.businessId,
      businessName: entity.businessName,
      email: entity.email,
      password: entity.password,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      businessDocument: entity.businessDocument,
      businessStatus: entity.businessStatus,
      businessVerified: entity.businessVerified,
    );
  }

  static List<BusinessAuthEntity> toEntityList(
    List<BusinessAuthHiveModel> models,
  ) {
    return models.map((e) => e.toEntity()).toList();
  }
}
