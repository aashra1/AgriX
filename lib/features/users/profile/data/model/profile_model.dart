import 'package:agrix/features/users/profile/domain/entity/profile_entity.dart';

class UserProfileApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? address;
  final String? profilePicture;
  final bool isAdmin;
  final String? role;
  final String? createdAt;
  final String? updatedAt;

  UserProfileApiModel({
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

  factory UserProfileApiModel.fromJson(Map<String, dynamic> json) {
    // Handle different response structures
    Map<String, dynamic> userData;
    if (json.containsKey('profile') && json['profile'] != null) {
      userData = json['profile'] as Map<String, dynamic>;
    } else if (json.containsKey('user') && json['user'] != null) {
      userData = json['user'] as Map<String, dynamic>;
    } else {
      userData = json;
    }

    return UserProfileApiModel(
      id: userData['_id']?.toString() ?? userData['id']?.toString(),
      fullName: userData['fullName']?.toString() ?? '',
      email: userData['email']?.toString() ?? '',
      phoneNumber: userData['phoneNumber']?.toString() ?? '',
      address: userData['address']?.toString(),
      profilePicture: userData['profilePicture']?.toString(),
      isAdmin: userData['isAdmin'] as bool? ?? false,
      role: userData['role']?.toString(),
      createdAt: userData['createdAt']?.toString(),
      updatedAt: userData['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      if (address != null) 'address': address,
      if (profilePicture != null) 'profilePicture': profilePicture,
      'isAdmin': isAdmin,
      if (role != null) 'role': role,
    };
  }

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      profilePicture: profilePicture,
      isAdmin: isAdmin,
      role: role,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  static List<UserProfileEntity> toEntityList(
    List<UserProfileApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}

class UpdateProfileRequestModel {
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? profilePicture;

  UpdateProfileRequestModel({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.address,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null && fullName!.isNotEmpty) 'fullName': fullName,
      if (email != null && email!.isNotEmpty) 'email': email,
      if (phoneNumber != null && phoneNumber!.isNotEmpty)
        'phoneNumber': phoneNumber,
      if (address != null && address!.isNotEmpty) 'address': address,
      if (profilePicture != null && profilePicture!.isNotEmpty)
        'profilePicture': profilePicture,
    };
  }
}

class ChangePasswordRequestModel {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}
