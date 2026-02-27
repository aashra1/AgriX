import 'package:agrix/features/business/buisness_dashboard/business_customers/domain/entity/business_customer_entity.dart';

class BusinessCustomerApiModel {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final int totalOrders;
  final double totalSpent;
  final String firstOrder;
  final String lastOrder;
  final List<String>? addresses;

  BusinessCustomerApiModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.totalOrders,
    required this.totalSpent,
    required this.firstOrder,
    required this.lastOrder,
    this.addresses,
  });

  factory BusinessCustomerApiModel.fromCustomerData({
    required String id,
    required String fullName,
    required String email,
    String? phone,
    required int totalOrders,
    required double totalSpent,
    required String firstOrder,
    required String lastOrder,
    List<String>? addresses,
  }) {
    return BusinessCustomerApiModel(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      totalOrders: totalOrders,
      totalSpent: totalSpent,
      firstOrder: firstOrder,
      lastOrder: lastOrder,
      addresses: addresses,
    );
  }

  BusinessCustomerEntity toEntity() {
    return BusinessCustomerEntity(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      totalOrders: totalOrders,
      totalSpent: totalSpent,
      firstOrder: DateTime.parse(firstOrder),
      lastOrder: DateTime.parse(lastOrder),
      addresses: addresses,
    );
  }

  static List<BusinessCustomerEntity> toEntityList(
    List<BusinessCustomerApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}
