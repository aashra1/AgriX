import 'package:agrix/features/users/profile/domain/entity/profile_entity.dart';
import 'package:equatable/equatable.dart';

enum UserProfileStatus { initial, loading, loaded, updating, updated, error }

class UserProfileState extends Equatable {
  final UserProfileStatus status;
  final UserProfileEntity? profile;
  final String? errorMessage;
  final bool isUpdating;

  const UserProfileState({
    this.status = UserProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.isUpdating = false,
  });

  UserProfileState copyWith({
    UserProfileStatus? status,
    UserProfileEntity? profile,
    String? errorMessage,
    bool? isUpdating,
  }) {
    return UserProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage, isUpdating];
}
