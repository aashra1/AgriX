import 'package:equatable/equatable.dart';

enum PaymentMethod { cod, khalti }

class AddressEntity extends Equatable {
  final String fullName;
  final String phone;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final bool isDefault;

  const AddressEntity({
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    this.isDefault = false,
  });

  AddressEntity copyWith({
    String? fullName,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    bool? isDefault,
  }) {
    return AddressEntity(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      isDefault: isDefault ?? this.isDefault,
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
    isDefault,
  ];
}

class CheckoutItemEntity extends Equatable {
  final String productId;
  final String name;
  final double price;
  final double discount;
  final int quantity;
  final String businessId;
  final String? image;

  const CheckoutItemEntity({
    required this.productId,
    required this.name,
    required this.price,
    this.discount = 0.0,
    required this.quantity,
    required this.businessId,
    this.image,
  });

  double get itemTotal {
    final itemPrice = discount > 0 ? price * (1 - discount / 100) : price;
    return itemPrice * quantity;
  }

  @override
  List<Object?> get props => [
    productId,
    name,
    price,
    discount,
    quantity,
    businessId,
    image,
  ];
}

class CheckoutSummaryEntity extends Equatable {
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;

  const CheckoutSummaryEntity({
    required this.subtotal,
    this.shipping = 0.0,
    required this.tax,
    required this.total,
  });

  @override
  List<Object?> get props => [subtotal, shipping, tax, total];
}
