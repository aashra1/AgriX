import 'package:agrix/features/business/buisness_dashboard/orders/domain/entity/business_order_entity.dart';
import 'package:hive/hive.dart';

part 'business_order_hive_model.g.dart';

@HiveType(typeId: 10)
class BusinessOrderItemHiveModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final String productName;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final double discount;

  @HiveField(5)
  final int quantity;

  @HiveField(6)
  final String? businessId;

  @HiveField(7)
  final String? businessName;

  @HiveField(8)
  final String? image;

  BusinessOrderItemHiveModel({
    this.id,
    required this.productId,
    required this.productName,
    required this.price,
    this.discount = 0.0,
    required this.quantity,
    this.businessId,
    this.businessName,
    this.image,
  });

  factory BusinessOrderItemHiveModel.fromEntity(
    BusinessOrderItemEntity entity,
  ) {
    return BusinessOrderItemHiveModel(
      id: entity.id,
      productId: entity.productId,
      productName: entity.productName,
      price: entity.price,
      discount: entity.discount,
      quantity: entity.quantity,
      businessId: entity.businessId,
      businessName: entity.businessName,
      image: entity.image,
    );
  }

  BusinessOrderItemEntity toEntity() {
    return BusinessOrderItemEntity(
      id: id,
      productId: productId,
      productName: productName,
      price: price,
      discount: discount,
      quantity: quantity,
      businessId: businessId,
      businessName: businessName,
      image: image,
    );
  }
}

@HiveType(typeId: 11)
class BusinessShippingAddressHiveModel {
  @HiveField(0)
  final String fullName;

  @HiveField(1)
  final String phone;

  @HiveField(2)
  final String addressLine1;

  @HiveField(3)
  final String? addressLine2;

  @HiveField(4)
  final String city;

  @HiveField(5)
  final String state;

  @HiveField(6)
  final String postalCode;

  BusinessShippingAddressHiveModel({
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  factory BusinessShippingAddressHiveModel.fromEntity(
    BusinessShippingAddressEntity entity,
  ) {
    return BusinessShippingAddressHiveModel(
      fullName: entity.fullName,
      phone: entity.phone,
      addressLine1: entity.addressLine1,
      addressLine2: entity.addressLine2,
      city: entity.city,
      state: entity.state,
      postalCode: entity.postalCode,
    );
  }

  BusinessShippingAddressEntity toEntity() {
    return BusinessShippingAddressEntity(
      fullName: fullName,
      phone: phone,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: state,
      postalCode: postalCode,
    );
  }
}

@HiveType(typeId: 12)
class BusinessOrderHiveModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String? userFullName;

  @HiveField(3)
  final String? userEmail;

  @HiveField(4)
  final String? userPhone;

  @HiveField(5)
  final List<BusinessOrderItemHiveModel> items;

  @HiveField(6)
  final BusinessShippingAddressHiveModel shippingAddress;

  @HiveField(7)
  final String paymentMethod;

  @HiveField(8)
  final String paymentStatus;

  @HiveField(9)
  final String orderStatus;

  @HiveField(10)
  final double subtotal;

  @HiveField(11)
  final double shipping;

  @HiveField(12)
  final double tax;

  @HiveField(13)
  final double total;

  @HiveField(14)
  final String? trackingNumber;

  @HiveField(15)
  final String? notes;

  @HiveField(16)
  final DateTime? createdAt;

  @HiveField(17)
  final DateTime? updatedAt;

  BusinessOrderHiveModel({
    this.id,
    required this.userId,
    this.userFullName,
    this.userEmail,
    this.userPhone,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.subtotal,
    this.shipping = 0.0,
    required this.tax,
    required this.total,
    this.trackingNumber,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessOrderHiveModel.fromEntity(BusinessOrderEntity entity) {
    return BusinessOrderHiveModel(
      id: entity.id,
      userId: entity.userId,
      userFullName: entity.userFullName,
      userEmail: entity.userEmail,
      userPhone: entity.userPhone,
      items:
          entity.items
              .map((item) => BusinessOrderItemHiveModel.fromEntity(item))
              .toList(),
      shippingAddress: BusinessShippingAddressHiveModel.fromEntity(
        entity.shippingAddress,
      ),
      paymentMethod: _paymentMethodToString(entity.paymentMethod),
      paymentStatus: _paymentStatusToString(entity.paymentStatus),
      orderStatus: _orderStatusToString(entity.orderStatus),
      subtotal: entity.subtotal,
      shipping: entity.shipping,
      tax: entity.tax,
      total: entity.total,
      trackingNumber: entity.trackingNumber,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  BusinessOrderEntity toEntity() {
    return BusinessOrderEntity(
      id: id,
      userId: userId,
      userFullName: userFullName,
      userEmail: userEmail,
      userPhone: userPhone,
      items: items.map((item) => item.toEntity()).toList(),
      shippingAddress: shippingAddress.toEntity(),
      paymentMethod: _parsePaymentMethod(paymentMethod),
      paymentStatus: _parsePaymentStatus(paymentStatus),
      orderStatus: _parseOrderStatus(orderStatus),
      subtotal: subtotal,
      shipping: shipping,
      tax: tax,
      total: total,
      trackingNumber: trackingNumber,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static List<BusinessOrderEntity> toEntityList(
    List<BusinessOrderHiveModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }

  static String _paymentMethodToString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.card:
        return 'card';
      case PaymentMethod.esewa:
        return 'esewa';
      case PaymentMethod.khalti:
        return 'khalti';
      case PaymentMethod.cod:
        return 'cod';
    }
  }

  static String _paymentStatusToString(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return 'paid';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.pending:
        return 'pending';
    }
  }

  static String _orderStatusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.pending:
        return 'pending';
    }
  }

  static PaymentMethod _parsePaymentMethod(String value) {
    switch (value.toLowerCase()) {
      case 'card':
        return PaymentMethod.card;
      case 'esewa':
        return PaymentMethod.esewa;
      case 'khalti':
        return PaymentMethod.khalti;
      case 'cod':
      default:
        return PaymentMethod.cod;
    }
  }

  static PaymentStatus _parsePaymentStatus(String value) {
    switch (value.toLowerCase()) {
      case 'paid':
        return PaymentStatus.paid;
      case 'failed':
        return PaymentStatus.failed;
      case 'pending':
      default:
        return PaymentStatus.pending;
    }
  }

  static OrderStatus _parseOrderStatus(String value) {
    switch (value.toLowerCase()) {
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'pending':
      default:
        return OrderStatus.pending;
    }
  }
}
