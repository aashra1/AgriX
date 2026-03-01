import 'package:equatable/equatable.dart';

enum BusinessStatus { pending, approved, rejected }

class BusinessProfileEntity extends Equatable {
  final String id;
  final String businessName;
  final String email;
  final String phoneNumber;
  final String? address;
  final String? profilePicture;
  final String? businessDocument;
  final bool businessVerified;
  final BusinessStatus businessStatus;
  final String? rejectionReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BusinessProfileEntity({
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

  BusinessProfileEntity copyWith({
    String? id,
    String? businessName,
    String? email,
    String? phoneNumber,
    String? address,
    String? profilePicture,
    String? businessDocument,
    bool? businessVerified,
    BusinessStatus? businessStatus,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BusinessProfileEntity(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      profilePicture: profilePicture ?? this.profilePicture,
      businessDocument: businessDocument ?? this.businessDocument,
      businessVerified: businessVerified ?? this.businessVerified,
      businessStatus: businessStatus ?? this.businessStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    businessName,
    email,
    phoneNumber,
    address,
    profilePicture,
    businessDocument,
    businessVerified,
    businessStatus,
    rejectionReason,
    createdAt,
    updatedAt,
  ];
}
