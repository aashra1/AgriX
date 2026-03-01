import 'package:agrix/features/users/cart/domain/entity/cart_entity.dart';

class CartItemApiModel {
  final String? id;
  final String product;
  final int quantity;
  final double price;
  final double discount;
  final String business;
  final String? businessName;
  final String? name;
  final String? image;

  CartItemApiModel({
    this.id,
    required this.product,
    required this.quantity,
    required this.price,
    this.discount = 0.0,
    required this.business,
    this.businessName,
    this.name,
    this.image,
  });

  factory CartItemApiModel.fromJson(Map<String, dynamic> json) {
    String? productId;
    if (json['product'] != null) {
      if (json['product'] is Map) {
        productId = json['product']['_id']?.toString();
      } else {
        productId = json['product']?.toString();
      }
    }

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

    String? itemName = json['name']?.toString();
    if (itemName == null && json['product'] is Map) {
      itemName = json['product']['name']?.toString();
    }

    return CartItemApiModel(
      id: json['_id']?.toString(),
      product: productId ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      business: businessId ?? '',
      businessName: businessName,
      name: itemName,
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'product': product,
      'quantity': quantity,
      'price': price,
      'discount': discount,
      'business': business,
      if (name != null) 'name': name,
      if (image != null) 'image': image,
    };
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      productId: product,
      quantity: quantity,
      price: price,
      discount: discount,
      businessId: business,
      businessName: businessName,
      name: name ?? '',
      image: image,
    );
  }
}

class CartApiModel {
  final String? id;
  final String user;
  final List<CartItemApiModel> items;
  final double totalAmount;
  final int totalItems;
  final String? createdAt;
  final String? updatedAt;

  CartApiModel({
    this.id,
    required this.user,
    required this.items,
    required this.totalAmount,
    required this.totalItems,
    this.createdAt,
    this.updatedAt,
  });

  factory CartApiModel.fromJson(Map<String, dynamic> json) {
    var itemsList = <CartItemApiModel>[];
    if (json['cart'] != null && json['cart']['items'] != null) {
      itemsList =
          (json['cart']['items'] as List)
              .map(
                (item) =>
                    CartItemApiModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
    } else if (json['items'] != null) {
      itemsList =
          (json['items'] as List)
              .map(
                (item) =>
                    CartItemApiModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
    }

    String? userId;
    if (json['cart'] != null && json['cart']['user'] != null) {
      if (json['cart']['user'] is Map) {
        userId = json['cart']['user']['_id']?.toString();
      } else {
        userId = json['cart']['user']?.toString();
      }
    } else if (json['user'] != null) {
      if (json['user'] is Map) {
        userId = json['user']['_id']?.toString();
      } else {
        userId = json['user']?.toString();
      }
    }

    double amount =
        json['cart'] != null
            ? (json['cart']['totalAmount'] as num?)?.toDouble() ?? 0.0
            : (json['totalAmount'] as num?)?.toDouble() ?? 0.0;

    int items =
        json['cart'] != null
            ? (json['cart']['totalItems'] as num?)?.toInt() ?? 0
            : (json['totalItems'] as num?)?.toInt() ?? 0;

    return CartApiModel(
      id: json['cart']?['_id']?.toString() ?? json['_id']?.toString(),
      user: userId ?? '',
      items: itemsList,
      totalAmount: amount,
      totalItems: items,
      createdAt:
          json['cart']?['createdAt']?.toString() ??
          json['createdAt']?.toString(),
      updatedAt:
          json['cart']?['updatedAt']?.toString() ??
          json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'user': user,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'totalItems': totalItems,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  CartEntity toEntity() {
    return CartEntity(
      id: id,
      userId: user,
      items: items.map((item) => item.toEntity()).toList(),
      totalAmount: totalAmount,
      totalItems: totalItems,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }
}
