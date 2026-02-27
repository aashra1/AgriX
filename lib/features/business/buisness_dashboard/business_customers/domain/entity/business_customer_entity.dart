// lib/features/business/buisness_dashboard/customers/domain/entity/business_customer_entity.dart
import 'package:equatable/equatable.dart';

class BusinessCustomerEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final int totalOrders;
  final double totalSpent;
  final DateTime firstOrder;
  final DateTime lastOrder;
  final List<String>? addresses;

  const BusinessCustomerEntity({
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

  BusinessCustomerEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    int? totalOrders,
    double? totalSpent,
    DateTime? firstOrder,
    DateTime? lastOrder,
    List<String>? addresses,
  }) {
    return BusinessCustomerEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      totalOrders: totalOrders ?? this.totalOrders,
      totalSpent: totalSpent ?? this.totalSpent,
      firstOrder: firstOrder ?? this.firstOrder,
      lastOrder: lastOrder ?? this.lastOrder,
      addresses: addresses ?? this.addresses,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phone,
    totalOrders,
    totalSpent,
    firstOrder,
    lastOrder,
    addresses,
  ];
}
