import 'package:agrix/features/business/auth/domain/entities/business_auth_entity.dart';
import 'package:equatable/equatable.dart';

enum BusinessAuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  registered,
  needsDocumentUpload,
  documentUploading,
  documentUploaded,
  error,
}

class BusinessAuthState extends Equatable {
  final BusinessAuthStatus status;
  final BusinessAuthEntity? businessEntity;
  final String? tempToken;
  final String? errorMessage;
  final String? uploadedDocumentPath;

  const BusinessAuthState({
    this.status = BusinessAuthStatus.initial,
    this.businessEntity,
    this.tempToken,
    this.errorMessage,
    this.uploadedDocumentPath,
  });

  BusinessAuthState copyWith({
    BusinessAuthStatus? status,
    BusinessAuthEntity? businessEntity,
    String? tempToken,
    String? errorMessage,
    String? uploadedDocumentPath,
  }) {
    return BusinessAuthState(
      status: status ?? this.status,
      businessEntity: businessEntity ?? this.businessEntity,
      tempToken: tempToken ?? this.tempToken,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadedDocumentPath: uploadedDocumentPath ?? this.uploadedDocumentPath,
    );
  }

  @override
  List<Object?> get props => [
    status,
    businessEntity,
    tempToken,
    errorMessage,
    uploadedDocumentPath,
  ];
}
