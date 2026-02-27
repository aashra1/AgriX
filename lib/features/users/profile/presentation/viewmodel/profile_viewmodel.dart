import 'package:agrix/features/users/profile/domain/usecase/profile_usecase.dart';
import 'package:agrix/features/users/profile/presentation/state/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileViewModelProvider =
    NotifierProvider<UserProfileViewModel, UserProfileState>(
      () => UserProfileViewModel(),
    );

class UserProfileViewModel extends Notifier<UserProfileState> {
  late GetUserProfileUsecase _getUserProfileUsecase;
  late UpdateUserProfileUsecase _updateUserProfileUsecase;
  late ChangePasswordUsecase _changePasswordUsecase;
  late ClearLocalProfileUsecase _clearLocalProfileUsecase;

  @override
  UserProfileState build() {
    _getUserProfileUsecase = ref.read(getUserProfileUsecaseProvider);
    _updateUserProfileUsecase = ref.read(updateUserProfileUsecaseProvider);
    _changePasswordUsecase = ref.read(changePasswordUsecaseProvider);
    _clearLocalProfileUsecase = ref.read(clearLocalProfileUsecaseProvider);
    return const UserProfileState();
  }

  Future<void> getUserProfile({required String token}) async {
    state = state.copyWith(status: UserProfileStatus.loading);

    final params = GetUserProfileUsecaseParams(token: token);
    final result = await _getUserProfileUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (profile) {
        state = state.copyWith(
          status: UserProfileStatus.loaded,
          profile: profile,
        );
      },
    );
  }

  Future<void> updateUserProfile({
    required String token,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    String? imagePath,
  }) async {
    state = state.copyWith(
      status: UserProfileStatus.updating,
      isUpdating: true,
    );

    final params = UpdateUserProfileUsecaseParams(
      token: token,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      imagePath: imagePath,
    );

    final result = await _updateUserProfileUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserProfileStatus.error,
          errorMessage: failure.message,
          isUpdating: false,
        );
      },
      (profile) {
        state = state.copyWith(
          status: UserProfileStatus.updated,
          profile: profile,
          isUpdating: false,
        );
      },
    );
  }

  Future<void> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = state.copyWith(
      status: UserProfileStatus.updating,
      isUpdating: true,
    );

    final params = ChangePasswordUsecaseParams(
      token: token,
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    final result = await _changePasswordUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserProfileStatus.error,
          errorMessage: failure.message,
          isUpdating: false,
        );
      },
      (success) {
        state = state.copyWith(
          status: UserProfileStatus.updated,
          isUpdating: false,
        );
      },
    );
  }

  Future<void> clearLocalProfile() async {
    await _clearLocalProfileUsecase.call();
  }

  void resetStatus() {
    if (state.status == UserProfileStatus.updated) {
      state = state.copyWith(status: UserProfileStatus.loaded);
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = const UserProfileState();
  }
}
