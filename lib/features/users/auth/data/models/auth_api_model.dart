import 'package:agrix/features/users/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String fullName;
  final String email;
  final String password;
  final String? phoneNumber;
  final String? address;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.address,
  });

  //To JSON
  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "address": address,
    };
  }

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> userData;
    if (json.containsKey('user') && json['user'] != null) {
      userData = json['user'] as Map<String, dynamic>;
      if (userData.containsKey('_doc')) {
        userData = userData['_doc'] as Map<String, dynamic>;
      }
    } else {
      userData = json;
    }

    return AuthApiModel(
      id: userData['_id'] as String?,
      fullName: userData['fullName'] as String? ?? '',
      email: userData['email'] as String? ?? '',
      password: userData['password'] as String? ?? '',
      phoneNumber: userData['phoneNumber'] as String?,
      address: userData['address'] as String?,
    );
  }

  // To AuthEntity
  AuthEntity toAuthEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      address: address,
    );
  }

  // From AuthEntity
  factory AuthApiModel.fromAuthEntity(AuthEntity entity) {
    return AuthApiModel(
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
    );
  }

  // To Entity List
  static List<AuthEntity> toAuthEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toAuthEntity()).toList();
  }
}
