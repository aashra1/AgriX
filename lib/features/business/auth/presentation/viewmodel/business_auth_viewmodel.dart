import 'package:agrix/features/business/auth/domain/entities/business_auth_entity.dart';
import 'package:agrix/features/business/auth/domain/use_cases/business_login_usecase.dart';
import 'package:agrix/features/business/auth/domain/use_cases/business_register_usecase.dart';
import 'package:agrix/features/business/auth/domain/use_cases/upload_document_usecase.dart';
import 'package:agrix/features/business/auth/presentation/state/business_auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessAuthViewModelProvider =
    NotifierProvider<BusinessAuthViewModel, BusinessAuthState>(
      () => BusinessAuthViewModel(),
    );

class BusinessAuthViewModel extends Notifier<BusinessAuthState> {
  late final BusinessRegisterUsecase _registerUsecase;
  late final BusinessLoginUsecase _loginUsecase;
  late final UploadDocumentUsecase _uploadDocumentUsecase;

  @override
  BusinessAuthState build() {
    _registerUsecase = ref.read(businessRegisterUsecaseProvider);
    _loginUsecase = ref.read(businessLoginUsecaseProvider);
    _uploadDocumentUsecase = ref.read(uploadDocumentUsecaseProvider);
    return BusinessAuthState();
  }

  Future<void> registerBusiness({
    required String businessName,
    required String email,
    required String password,
    required String phoneNumber,
    String? address,
  }) async {
    state = state.copyWith(status: BusinessAuthStatus.loading);

    final registerParams = BusinessRegisterUsecaseParams(
      businessName: businessName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      address: address,
    );

    final result = await _registerUsecase.call(registerParams);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: BusinessAuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (response) {
        final business = response['business'] as BusinessAuthEntity;
        final tempToken = response['tempToken'] as String?;

        if (tempToken != null) {
          state = state.copyWith(
            status: BusinessAuthStatus.needsDocumentUpload,
            businessEntity: business,
            tempToken: tempToken,
          );
        } else {
          state = state.copyWith(
            status: BusinessAuthStatus.registered,
            businessEntity: business,
          );
        }
      },
    );
  }

  Future<void> loginBusiness({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: BusinessAuthStatus.loading);

    final loginParams = BusinessLoginUsecaseParams(
      email: email,
      password: password,
    );

    final result = await _loginUsecase(loginParams);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: BusinessAuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (businessEntity) {
        if (businessEntity.businessStatus == 'Pending') {
          state = state.copyWith(
            status: BusinessAuthStatus.needsDocumentUpload,
            businessEntity: businessEntity,
          );
        } else {
          state = state.copyWith(
            status: BusinessAuthStatus.authenticated,
            businessEntity: businessEntity,
          );
        }
      },
    );
  }

  Future<void> uploadBusinessDocument({
    required String businessId,
    required String documentPath,
  }) async {
    state = state.copyWith(status: BusinessAuthStatus.documentUploading);

    final token = state.tempToken;

    if (token == null) {
      state = state.copyWith(
        status: BusinessAuthStatus.error,
        errorMessage: 'No temporary token found. Please register again.',
      );
      return;
    }

    final uploadParams = UploadDocumentUsecaseParams(
      businessId: businessId,
      documentPath: documentPath,
      token: token,
    );

    final result = await _uploadDocumentUsecase.call(uploadParams);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: BusinessAuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (updatedBusiness) {
        state = state.copyWith(
          status: BusinessAuthStatus.documentUploaded,
          businessEntity: updatedBusiness,
          uploadedDocumentPath: documentPath,
          tempToken: null,
        );
      },
    );
  }

  // Clear error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  // Reset state
  void reset() {
    state = BusinessAuthState();
  }
}
