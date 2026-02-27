import 'package:agrix/features/business/buisness_dashboard/orders/domain/entity/business_order_entity.dart';

class BusinessOrderItemApiModel {
  final String? id;
  final String product;
  final String name;
  final double price;
  final double discount;
  final int quantity;
  final String? business;
  final String? image;

  BusinessOrderItemApiModel({
    this.id,
    required this.product,
    required this.name,
    required this.price,
    this.discount = 0.0,
    required this.quantity,
    this.business,
    this.image,
  });

  factory BusinessOrderItemApiModel.fromJson(Map<String, dynamic> json) {
    String? businessId;
    if (json['business'] != null) {
      if (json['business'] is Map) {
        businessId = json['business']['_id']?.toString();
      } else {
        businessId = json['business']?.toString();
      }
    }

    return BusinessOrderItemApiModel(
      id: json['_id']?.toString(),
      product: json['product']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      business: businessId,
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
      if (business != null) 'business': business,
      if (image != null) 'image': image,
    };
  }

  BusinessOrderItemEntity toEntity() {
    return BusinessOrderItemEntity(
      id: id,
      productId: product,
      productName: name,
      price: price,
      discount: discount,
      quantity: quantity,
      businessId: business,
      image: image,
    );
  }
}

class BusinessShippingAddressApiModel {
  final String fullName;
  final String phone;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;

  BusinessShippingAddressApiModel({
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  factory BusinessShippingAddressApiModel.fromJson(Map<String, dynamic> json) {
    return BusinessShippingAddressApiModel(
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

class BusinessOrderApiModel {
  final String? id;
  final String user;
  final Map<String, dynamic>? userData;
  final List<BusinessOrderItemApiModel> items;
  final BusinessShippingAddressApiModel shippingAddress;
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

  BusinessOrderApiModel({
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

  factory BusinessOrderApiModel.fromJson(Map<String, dynamic> json) {
    var itemsList = <BusinessOrderItemApiModel>[];
    if (json['items'] != null) {
      itemsList =
          (json['items'] as List)
              .map(
                (item) => BusinessOrderItemApiModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
    }

    Map<String, dynamic>? userInfo;
    if (json['user'] != null && json['user'] is Map) {
      userInfo = json['user'] as Map<String, dynamic>;
    }

    return BusinessOrderApiModel(
      id: json['_id']?.toString(),
      user: json['user']?.toString() ?? '',
      userData: userInfo,
      items: itemsList,
      shippingAddress: BusinessShippingAddressApiModel.fromJson(
        json['shippingAddress'] as Map<String, dynamic>? ?? {},
      ),
      paymentMethod: json['paymentMethod']?.toString() ?? 'cod',
      paymentStatus: json['paymentStatus']?.toString() ?? 'pending',
      orderStatus: json['orderStatus']?.toString() ?? 'pending',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      shipping: (json['shipping'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      trackingNumber: json['trackingNumber']?.toString(),
      notes: json['notes']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
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
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  BusinessOrderEntity toEntity() {
    String? userFullName;
    String? userEmail;
    String? userPhone;

    if (userData != null) {
      userFullName = userData!['fullName']?.toString();
      userEmail = userData!['email']?.toString();
      userPhone = userData!['phone']?.toString();
    }

    return BusinessOrderEntity(
      id: id,
      userId: user,
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
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  static List<BusinessOrderEntity> toEntityList(
    List<BusinessOrderApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }

  PaymentMethod _parsePaymentMethod(String value) {
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

  PaymentStatus _parsePaymentStatus(String value) {
    switch (value.toLowerCase()) {
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'pending':
      default:
        return PaymentStatus.pending;
    }
  }

  OrderStatus _parseOrderStatus(String value) {
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
