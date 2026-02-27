import 'package:agrix/features/users/profile/data/model/profile_hive_model.dart';
import 'package:agrix/features/users/profile/data/model/profile_model.dart';

abstract class IUserProfileLocalDatasource {
  Future<bool> saveProfile(UserProfileHiveModel profile);
  Future<UserProfileHiveModel?> getProfile();
  Future<bool> updateProfile(UserProfileHiveModel profile);
  Future<bool> deleteProfile();
  Future<bool> clearProfiles();
}

abstract interface class IUserProfileRemoteDatasource {
  Future<UserProfileApiModel> getUserProfile({required String token});

  Future<UserProfileApiModel> updateUserProfile({
    required String token,
    required Map<String, dynamic> profileData,
    String? imagePath,
  });

  Future<bool> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
}
