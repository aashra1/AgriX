import 'package:equatable/equatable.dart';

enum UserOrderPaymentMethod { cod, khalti }

enum UserOrderPaymentStatus { pending, completed, failed, refunded }

enum UserOrderStatus { pending, processing, shipped, delivered, cancelled }

class UserOrderItemEntity extends Equatable {
  final String? id;
  final String productId;
  final String productName;
  final double price;
  final double discount;
  final int quantity;
  final String businessId;
  final String? businessName;
  final String? image;

  const UserOrderItemEntity({
    this.id,
    required this.productId,
    required this.productName,
    required this.price,
    this.discount = 0.0,
    required this.quantity,
    required this.businessId,
    this.businessName,
    this.image,
  });

  double get itemTotal {
    final itemPrice = price * quantity;
    final discountAmount = itemPrice * (discount / 100);
    return itemPrice - discountAmount;
  }

  UserOrderItemEntity copyWith({
    String? id,
    String? productId,
    String? productName,
    double? price,
    double? discount,
    int? quantity,
    String? businessId,
    String? businessName,
    String? image,
  }) {
    return UserOrderItemEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      quantity: quantity ?? this.quantity,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    price,
    discount,
    quantity,
    businessId,
    businessName,
    image,
  ];
}

class UserOrderShippingAddressEntity extends Equatable {
  final String fullName;
  final String phone;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;

  const UserOrderShippingAddressEntity({
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  UserOrderShippingAddressEntity copyWith({
    String? fullName,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
  }) {
    return UserOrderShippingAddressEntity(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
    );
  }

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

class UserOrderEntity extends Equatable {
  final String? id;
  final String userId;
  final List<UserOrderItemEntity> items;
  final UserOrderShippingAddressEntity shippingAddress;
  final UserOrderPaymentMethod paymentMethod;
  final UserOrderPaymentStatus paymentStatus;
  final UserOrderStatus orderStatus;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final String? trackingNumber;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserOrderEntity({
    this.id,
    required this.userId,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
    this.paymentStatus = UserOrderPaymentStatus.pending,
    this.orderStatus = UserOrderStatus.pending,
    required this.subtotal,
    this.shipping = 0.0,
    required this.tax,
    required this.total,
    this.trackingNumber,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  UserOrderEntity copyWith({
    String? id,
    String? userId,
    List<UserOrderItemEntity>? items,
    UserOrderShippingAddressEntity? shippingAddress,
    UserOrderPaymentMethod? paymentMethod,
    UserOrderPaymentStatus? paymentStatus,
    UserOrderStatus? orderStatus,
    double? subtotal,
    double? shipping,
    double? tax,
    double? total,
    String? trackingNumber,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserOrderEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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
