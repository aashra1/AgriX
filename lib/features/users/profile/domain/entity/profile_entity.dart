import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String? id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? address;
  final String? profilePicture;
  final bool isAdmin;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfileEntity({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.address,
    this.profilePicture,
    this.isAdmin = false,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  UserProfileEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    String? profilePicture,
    bool? isAdmin,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      profilePicture: profilePicture ?? this.profilePicture,
      isAdmin: isAdmin ?? this.isAdmin,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phoneNumber,
    address,
    profilePicture,
    isAdmin,
    role,
    createdAt,
    updatedAt,
  ];
}
