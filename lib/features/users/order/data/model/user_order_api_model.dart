import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';

class UserOrderItemApiModel {
  final String? id;
  final String product;
  final String name;
  final double price;
  final double discount;
  final int quantity;
  final String business;
  final String? businessName;
  final String? image;

  UserOrderItemApiModel({
    this.id,
    required this.product,
    required this.name,
    required this.price,
    this.discount = 0.0,
    required this.quantity,
    required this.business,
    this.businessName,
    this.image,
  });

  factory UserOrderItemApiModel.fromJson(Map<String, dynamic> json) {
    String? businessId;
    String? businessName;
    if (json['business'] != null) {
      if (json['business'] is Map) {
        businessId = json['business']['_id']?.toString();
        businessName = json['business']['businessName']?.toString();
      } else {
        businessId = json['business']?.toString();
      }
    }

    return UserOrderItemApiModel(
      id: json['_id']?.toString(),
      product: json['product']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      business: businessId ?? '',
      businessName: businessName,
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'product': product,
      'name': name,
      'price': price,
      'discount': discount,
      'quantity': quantity,
      'business': business,
      if (image != null) 'image': image,
    };
  }

  UserOrderItemEntity toEntity() {
    return UserOrderItemEntity(
      id: id,
      productId: product,
      productName: name,
      price: price,
      discount: discount,
      quantity: quantity,
      businessId: business,
      businessName: businessName,
      image: image,
    );
  }
}

class UserOrderShippingAddressApiModel {
  final String fullName;
  final String phone;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;

  UserOrderShippingAddressApiModel({
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  factory UserOrderShippingAddressApiModel.fromJson(Map<String, dynamic> json) {
    return UserOrderShippingAddressApiModel(
      fullName: json['fullName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      addressLine1: json['addressLine1']?.toString() ?? '',
      addressLine2: json['addressLine2']?.toString(),
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      postalCode: json['postalCode']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'addressLine1': addressLine1,
      if (addressLine2 != null) 'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
    };
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

class UserOrderApiModel {
  final String? id;
  final String user;
  final Map<String, dynamic>? userData;
  final List<UserOrderItemApiModel> items;
  final UserOrderShippingAddressApiModel shippingAddress;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final String? trackingNumber;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  UserOrderApiModel({
    this.id,
    required this.user,
    this.userData,
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

  factory UserOrderApiModel.fromJson(Map<String, dynamic> json) {
    var itemsList = <UserOrderItemApiModel>[];
    if (json['order'] != null && json['order']['items'] != null) {
      itemsList =
          (json['order']['items'] as List)
              .map(
                (item) => UserOrderItemApiModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
    } else if (json['items'] != null) {
      itemsList =
          (json['items'] as List)
              .map(
                (item) => UserOrderItemApiModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
    }

    Map<String, dynamic>? userInfo;
    if (json['user'] != null && json['user'] is Map) {
      userInfo = json['user'] as Map<String, dynamic>;
    }

    Map<String, dynamic> orderData = json['order'] ?? json;

    return UserOrderApiModel(
      id: orderData['_id']?.toString(),
      user: orderData['user']?.toString() ?? json['user']?.toString() ?? '',
      userData: userInfo,
      items: itemsList,
      shippingAddress: UserOrderShippingAddressApiModel.fromJson(
        orderData['shippingAddress'] as Map<String, dynamic>? ?? {},
      ),
      paymentMethod: orderData['paymentMethod']?.toString() ?? 'cod',
      paymentStatus: orderData['paymentStatus']?.toString() ?? 'pending',
      orderStatus: orderData['orderStatus']?.toString() ?? 'pending',
      subtotal: (orderData['subtotal'] as num?)?.toDouble() ?? 0.0,
      shipping: (orderData['shipping'] as num?)?.toDouble() ?? 0.0,
      tax: (orderData['tax'] as num?)?.toDouble() ?? 0.0,
      total: (orderData['total'] as num?)?.toDouble() ?? 0.0,
      trackingNumber: orderData['trackingNumber']?.toString(),
      notes: orderData['notes']?.toString(),
      createdAt: orderData['createdAt']?.toString(),
      updatedAt: orderData['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'user': user,
      'items': items.map((item) => item.toJson()).toList(),
      'shippingAddress': shippingAddress.toJson(),
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'total': total,
      if (trackingNumber != null) 'trackingNumber': trackingNumber,
      if (notes != null) 'notes': notes,
    };
  }

  UserOrderEntity toEntity() {
    return UserOrderEntity(
      id: id,
      userId: user,
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
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  static List<UserOrderEntity> toEntityList(List<UserOrderApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  UserOrderPaymentMethod _parsePaymentMethod(String value) {
    switch (value.toLowerCase()) {
      case 'khalti':
        return UserOrderPaymentMethod.khalti;
      case 'cod':
      default:
        return UserOrderPaymentMethod.cod;
    }
  }

  UserOrderPaymentStatus _parsePaymentStatus(String value) {
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

  UserOrderStatus _parseOrderStatus(String value) {
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
