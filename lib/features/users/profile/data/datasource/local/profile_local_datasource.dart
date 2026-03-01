import 'package:agrix/core/services/hive/hive_service.dart';
import 'package:agrix/features/users/profile/data/datasource/profile_datasource.dart';
import 'package:agrix/features/users/profile/data/model/profile_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileLocalDatasourceProvider =
    Provider<IUserProfileLocalDatasource>((ref) {
      final hiveService = ref.read(hiveServiceProvider);
      return UserProfileLocalDatasource(hiveService: hiveService);
    });

class UserProfileLocalDatasource implements IUserProfileLocalDatasource {
  final HiveService _hiveService;

  UserProfileLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> saveProfile(UserProfileHiveModel profile) async {
    try {
      await _hiveService.saveUserProfile(profile);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserProfileHiveModel?> getProfile() async {
    try {
      return _hiveService.getUserProfile();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateProfile(UserProfileHiveModel profile) async {
    try {
      await _hiveService.updateUserProfile(profile);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteProfile() async {
    try {
      await _hiveService.deleteUserProfile();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> clearProfiles() async {
    try {
      await _hiveService.clearUserProfiles();
      return true;
    } catch (e) {
      return false;
    }
  }
}
