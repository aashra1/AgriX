// lib/features/business/business_dashboard/order/domain/entity/business_order_entity.dart
import 'package:equatable/equatable.dart';

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

enum PaymentStatus { pending, paid, failed }

enum PaymentMethod { cod, card, esewa, khalti }

class BusinessOrderItemEntity extends Equatable {
  final String? id;
  final String productId;
  final String productName;
  final double price;
  final double discount;
  final int quantity;
  final String? image;
  final String? businessId;
  final String? businessName;

  const BusinessOrderItemEntity({
    this.id,
    required this.productId,
    required this.productName,
    required this.price,
    this.discount = 0.0,
    required this.quantity,
    this.image,
    this.businessId,
    this.businessName,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    price,
    discount,
    quantity,
    image,
    businessId,
    businessName,
  ];
}

class BusinessShippingAddressEntity extends Equatable {
  final String fullName;
  final String phone;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;

  const BusinessShippingAddressEntity({
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  @override
  List<Object?> get props => [
    fullName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
  ];
}

class BusinessOrderEntity extends Equatable {
  final String? id;
  final String userId;
  final String? userFullName;
  final String? userEmail;
  final String? userPhone;
  final List<BusinessOrderItemEntity> items;
  final BusinessShippingAddressEntity shippingAddress;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final OrderStatus orderStatus;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final String? trackingNumber;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BusinessOrderEntity({
    this.id,
    required this.userId,
    this.userFullName,
    this.userEmail,
    this.userPhone,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
    this.paymentStatus = PaymentStatus.pending,
    this.orderStatus = OrderStatus.pending,
    required this.subtotal,
    this.shipping = 0.0,
    required this.tax,
    required this.total,
    this.trackingNumber,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  BusinessOrderEntity copyWith({
    String? id,
    String? userId,
    String? userFullName,
    String? userEmail,
    String? userPhone,
    List<BusinessOrderItemEntity>? items,
    BusinessShippingAddressEntity? shippingAddress,
    PaymentMethod? paymentMethod,
    PaymentStatus? paymentStatus,
    OrderStatus? orderStatus,
    double? subtotal,
    double? shipping,
    double? tax,
    double? total,
    String? trackingNumber,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BusinessOrderEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userFullName: userFullName ?? this.userFullName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      items: items ?? this.items,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      subtotal: subtotal ?? this.subtotal,
      shipping: shipping ?? this.shipping,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    userFullName,
    userEmail,
    userPhone,
    items,
    shippingAddress,
    paymentMethod,
    paymentStatus,
    orderStatus,
    subtotal,
    shipping,
    tax,
    total,
    trackingNumber,
    notes,
    createdAt,
    updatedAt,
  ];
}
