import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:hive/hive.dart';

part 'user_order_hive_model.g.dart';

@HiveType(typeId: 16)
class UserOrderItemHiveModel {
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
  final String businessId;

  @HiveField(7)
  final String? businessName;

  @HiveField(8)
  final String? image;

  UserOrderItemHiveModel({
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

  factory UserOrderItemHiveModel.fromEntity(UserOrderItemEntity entity) {
    return UserOrderItemHiveModel(
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

  UserOrderItemEntity toEntity() {
    return UserOrderItemEntity(
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

@HiveType(typeId: 17)
class UserOrderShippingAddressHiveModel {
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

  UserOrderShippingAddressHiveModel({
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  factory UserOrderShippingAddressHiveModel.fromEntity(
    UserOrderShippingAddressEntity entity,
  ) {
    return UserOrderShippingAddressHiveModel(
      fullName: entity.fullName,
      phone: entity.phone,
      addressLine1: entity.addressLine1,
      addressLine2: entity.addressLine2,
      city: entity.city,
      state: entity.state,
      postalCode: entity.postalCode,
    );
  }

  UserOrderShippingAddressEntity toEntity() {
    return UserOrderShippingAddressEntity(
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

@HiveType(typeId: 18)
class UserOrderHiveModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final List<UserOrderItemHiveModel> items;

  @HiveField(3)
  final UserOrderShippingAddressHiveModel shippingAddress;

  @HiveField(4)
  final String paymentMethod;

  @HiveField(5)
  final String paymentStatus;

  @HiveField(6)
  final String orderStatus;

  @HiveField(7)
  final double subtotal;

  @HiveField(8)
  final double shipping;

  @HiveField(9)
  final double tax;

  @HiveField(10)
  final double total;

  @HiveField(11)
  final String? trackingNumber;

  @HiveField(12)
  final String? notes;

  @HiveField(13)
  final DateTime? createdAt;

  @HiveField(14)
  final DateTime? updatedAt;

  UserOrderHiveModel({
    this.id,
    required this.userId,
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

  factory UserOrderHiveModel.fromEntity(UserOrderEntity entity) {
    return UserOrderHiveModel(
      id: entity.id,
      userId: entity.userId,
      items:
          entity.items
              .map((item) => UserOrderItemHiveModel.fromEntity(item))
              .toList(),
      shippingAddress: UserOrderShippingAddressHiveModel.fromEntity(
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

  UserOrderEntity toEntity() {
    return UserOrderEntity(
      id: id,
      userId: userId,
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

  static List<UserOrderEntity> toEntityList(List<UserOrderHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  static String _paymentMethodToString(UserOrderPaymentMethod method) {
    switch (method) {
      case UserOrderPaymentMethod.khalti:
        return 'khalti';
      case UserOrderPaymentMethod.cod:
        return 'cod';
    }
  }

  static String _paymentStatusToString(UserOrderPaymentStatus status) {
    switch (status) {
      case UserOrderPaymentStatus.completed:
        return 'completed';
      case UserOrderPaymentStatus.failed:
        return 'failed';
      case UserOrderPaymentStatus.pending:
        return 'pending';
      case UserOrderPaymentStatus.refunded:
        return 'refunded';
    }
  }

  static String _orderStatusToString(UserOrderStatus status) {
    switch (status) {
      case UserOrderStatus.processing:
        return 'processing';
      case UserOrderStatus.shipped:
        return 'shipped';
      case UserOrderStatus.delivered:
        return 'delivered';
      case UserOrderStatus.cancelled:
        return 'cancelled';
      case UserOrderStatus.pending:
        return 'pending';
    }
  }

  static UserOrderPaymentMethod _parsePaymentMethod(String value) {
    switch (value.toLowerCase()) {
      case 'khalti':
        return UserOrderPaymentMethod.khalti;
      case 'cod':
      default:
        return UserOrderPaymentMethod.cod;
    }
  }

  static UserOrderPaymentStatus _parsePaymentStatus(String value) {
    switch (value.toLowerCase()) {
      case 'completed':
        return UserOrderPaymentStatus.completed;
      case 'failed':
        return UserOrderPaymentStatus.failed;
      case 'refunded':
        return UserOrderPaymentStatus.refunded;
      case 'pending':
        return UserOrderPaymentStatus.pending;
      default:
        return UserOrderPaymentStatus.pending;
    }
  }

  static UserOrderStatus _parseOrderStatus(String value) {
    switch (value.toLowerCase()) {
      case 'processing':
        return UserOrderStatus.processing;
      case 'shipped':
        return UserOrderStatus.shipped;
      case 'delivered':
        return UserOrderStatus.delivered;
      case 'cancelled':
        return UserOrderStatus.cancelled;
      case 'pending':
      default:
        return UserOrderStatus.pending;
    }
  }
}
