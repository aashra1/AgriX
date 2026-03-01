class BusinessAuthEntity {
  final String? businessId;
  final String businessName;
  final String email;
  final String password;
  final String phoneNumber;
  final String? address;
  final String? businessDocument;
  final String? businessStatus;
  final bool? businessVerified;

  const BusinessAuthEntity({
    this.businessId,
    required this.businessName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    this.address,
    this.businessDocument,
    this.businessStatus,
    this.businessVerified,
  });
}
