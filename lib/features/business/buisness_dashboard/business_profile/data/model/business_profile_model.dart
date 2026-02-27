import 'package:agrix/features/business/buisness_dashboard/business_profile/domain/entity/business_profile_entity.dart';

class BusinessProfileApiModel {
  final String id;
  final String businessName;
  final String email;
  final String phoneNumber;
  final String? address;
  final String? profilePicture;
  final String? businessDocument;
  final bool businessVerified;
  final String businessStatus;
  final String? rejectionReason;
  final String? createdAt;
  final String? updatedAt;

  BusinessProfileApiModel({
    required this.id,
    required this.businessName,
    required this.email,
    required this.phoneNumber,
    this.address,
    this.profilePicture,
    this.businessDocument,
    required this.businessVerified,
    required this.businessStatus,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessProfileApiModel.fromJson(Map<String, dynamic> json) {
    String? profilePic;
    if (json['profilePicture'] != null) {
      profilePic = json['profilePicture'].toString();
    }

    return BusinessProfileApiModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      businessName: json['businessName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      address: json['address']?.toString(),
      profilePicture: profilePic,
      businessDocument: json['businessDocument']?.toString(),
      businessVerified: json['businessVerified'] as bool? ?? false,
      businessStatus: json['businessStatus']?.toString() ?? 'Pending',
      rejectionReason: json['rejectionReason']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'businessName': businessName,
      'email': email,
      'phoneNumber': phoneNumber,
      if (address != null) 'address': address,
      if (profilePicture != null) 'profilePicture': profilePicture,
      if (businessDocument != null) 'businessDocument': businessDocument,
      'businessVerified': businessVerified,
      'businessStatus': businessStatus,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
    };
  }

  BusinessProfileEntity toEntity() {
    return BusinessProfileEntity(
      id: id,
      businessName: businessName,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      profilePicture: profilePicture,
      businessDocument: businessDocument,
      businessVerified: businessVerified,
      businessStatus: _parseStatus(businessStatus),
      rejectionReason: rejectionReason,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  BusinessStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return BusinessStatus.approved;
      case 'rejected':
        return BusinessStatus.rejected;
      case 'pending':
      default:
        return BusinessStatus.pending;
    }
  }
}

class UpdateProfileRequestModel {
  final String? businessName;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? profilePicture;

  UpdateProfileRequestModel({
    this.businessName,
    this.email,
    this.phoneNumber,
    this.address,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      if (businessName != null && businessName!.isNotEmpty)
        'businessName': businessName,
      if (email != null && email!.isNotEmpty) 'email': email,
      if (phoneNumber != null && phoneNumber!.isNotEmpty)
        'phoneNumber': phoneNumber,
      if (address != null && address!.isNotEmpty) 'address': address,
      if (profilePicture != null && profilePicture!.isNotEmpty)
        'profilePicture': profilePicture,
    };
  }
}
