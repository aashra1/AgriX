import 'package:agrix/features/business/auth/domain/entities/business_auth_entity.dart';

class BusinessAuthApiModel {
  final String? id;
  final String businessName;
  final String email;
  final String password;
  final String phoneNumber;
  final String? address;
  final String? businessDocument;
  final String? businessStatus;
  final bool? businessVerified;

  BusinessAuthApiModel({
    this.id,
    required this.businessName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    this.address,
    this.businessDocument,
    this.businessStatus,
    this.businessVerified,
  });

  // To JSON for registration
  Map<String, dynamic> toJson() {
    return {
      "businessName": businessName,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "address": address,
    };
  }

  factory BusinessAuthApiModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> businessData;

    if (json.containsKey('business') && json['business'] != null) {
      businessData = json['business'] as Map<String, dynamic>;
    } else {
      businessData = json;
    }

    return BusinessAuthApiModel(
      id: businessData['_id'] as String?,
      businessName: businessData['businessName'] as String? ?? '',
      email: businessData['email'] as String? ?? '',
      password: businessData['password'] as String? ?? '',
      phoneNumber: businessData['phoneNumber'] as String? ?? '',
      address: businessData['address'] as String?,
      businessDocument: businessData['businessDocument'] as String?,
      businessStatus: businessData['businessStatus'] as String?,
      businessVerified: businessData['businessVerified'] as bool?,
    );
  }

  // To BusinessAuthEntity
  BusinessAuthEntity toBusinessAuthEntity() {
    return BusinessAuthEntity(
      businessId: id,
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

  // From BusinessAuthEntity
  factory BusinessAuthApiModel.fromBusinessAuthEntity(
    BusinessAuthEntity entity,
  ) {
    return BusinessAuthApiModel(
      id: entity.businessId,
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
}
