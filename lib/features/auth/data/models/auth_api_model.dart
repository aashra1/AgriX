import 'package:agrix/features/auth/domain/entities/auth_entity.dart';


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


  // From JSON
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? json;

    return AuthApiModel(
      id: userJson['_id'] as String?,
      fullName: userJson['fullName'] as String? ?? '',
      email: userJson['email'] as String? ?? '',
      password: userJson['password'] as String? ?? '',
      phoneNumber: userJson['phoneNumber'] as String?,
      address: userJson['address'] as String?,
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
