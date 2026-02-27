import 'package:agrix/features/business/buisness_dashboard/business_profile/domain/usecase/business_profile_usecase.dart';
import 'package:agrix/features/business/buisness_dashboard/business_profile/presentation/state/business_profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessProfileViewModelProvider =
    NotifierProvider<BusinessProfileViewModel, BusinessProfileState>(
      () => BusinessProfileViewModel(),
    );

class BusinessProfileViewModel extends Notifier<BusinessProfileState> {
  late GetBusinessProfileUsecase _getBusinessProfileUsecase;
  late UpdateBusinessProfileUsecase _updateBusinessProfileUsecase;

  @override
  BusinessProfileState build() {
    _getBusinessProfileUsecase = ref.read(getBusinessProfileUsecaseProvider);
    _updateBusinessProfileUsecase = ref.read(
      updateBusinessProfileUsecaseProvider,
    );
    return const BusinessProfileState();
  }

  Future<void> getBusinessProfile({required String token}) async {
    state = state.copyWith(status: BusinessProfileStatus.loading);

    final params = GetBusinessProfileUsecaseParams(token: token);
    final result = await _getBusinessProfileUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: BusinessProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (profile) {
        state = state.copyWith(
          status: BusinessProfileStatus.loaded,
          profile: profile,
        );
      },
    );
  }

  Future<void> updateBusinessProfile({
    required String token,
    String? businessName,
    String? email,
    String? phoneNumber,
    String? address,
    String? imagePath,
  }) async {
    state = state.copyWith(
      status: BusinessProfileStatus.updating,
      isUpdating: true,
    );

    final params = UpdateBusinessProfileUsecaseParams(
      token: token,
      businessName: businessName,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      imagePath: imagePath,
    );

    final result = await _updateBusinessProfileUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: BusinessProfileStatus.error,
          errorMessage: failure.message,
          isUpdating: false,
        );
      },
      (profile) {
        state = state.copyWith(
          status: BusinessProfileStatus.updated,
          profile: profile,
          isUpdating: false,
        );
      },
    );
  }

  void resetStatus() {
    if (state.status == BusinessProfileStatus.updated) {
      state = state.copyWith(status: BusinessProfileStatus.loaded);
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = const BusinessProfileState();
  }
}
