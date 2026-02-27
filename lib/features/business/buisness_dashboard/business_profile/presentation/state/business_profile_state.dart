import 'package:agrix/features/business/buisness_dashboard/business_profile/domain/entity/business_profile_entity.dart';
import 'package:equatable/equatable.dart';

enum BusinessProfileStatus {
  initial,
  loading,
  loaded,
  updating,
  updated,
  error,
}

class BusinessProfileState extends Equatable {
  final BusinessProfileStatus status;
  final BusinessProfileEntity? profile;
  final String? errorMessage;
  final bool isUpdating;

  const BusinessProfileState({
    this.status = BusinessProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.isUpdating = false,
  });

  BusinessProfileState copyWith({
    BusinessProfileStatus? status,
    BusinessProfileEntity? profile,
    String? errorMessage,
    bool? isUpdating,
  }) {
    return BusinessProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage, isUpdating];
}
