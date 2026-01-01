class AuthEntity {
  final String? authId;
  final String fullName;
  final String email;
  final String password;
  final String? phoneNumber;
  final String? address;

  const AuthEntity({
    this.authId,
    required this.fullName,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.address,
  });
}
