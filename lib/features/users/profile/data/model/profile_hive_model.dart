import 'package:agrix/features/users/profile/domain/entity/profile_entity.dart';
import 'package:hive/hive.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: 13)
class UserProfileHiveModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String? address;

  @HiveField(5)
  final String? profilePicture;

  @HiveField(6)
  final bool isAdmin;

  @HiveField(7)
  final String? role;

  @HiveField(8)
  final DateTime? createdAt;

  @HiveField(9)
  final DateTime? updatedAt;

  UserProfileHiveModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.address,
    this.profilePicture,
    required this.isAdmin,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfileHiveModel.fromEntity(UserProfileEntity entity) {
    return UserProfileHiveModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      profilePicture: entity.profilePicture,
      isAdmin: entity.isAdmin,
      role: entity.role,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
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
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static List<UserProfileEntity> toEntityList(
    List<UserProfileHiveModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}
