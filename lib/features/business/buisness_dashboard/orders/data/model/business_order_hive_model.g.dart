// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_order_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessOrderItemHiveModelAdapter
    extends TypeAdapter<BusinessOrderItemHiveModel> {
  @override
  final int typeId = 10;

  @override
  BusinessOrderItemHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessOrderItemHiveModel(
      id: fields[0] as String?,
      productId: fields[1] as String,
      productName: fields[2] as String,
      price: fields[3] as double,
      discount: fields[4] as double,
      quantity: fields[5] as int,
      businessId: fields[6] as String?,
      businessName: fields[7] as String?,
      image: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessOrderItemHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.discount)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.businessId)
      ..writeByte(7)
      ..write(obj.businessName)
      ..writeByte(8)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessOrderItemHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BusinessShippingAddressHiveModelAdapter
    extends TypeAdapter<BusinessShippingAddressHiveModel> {
  @override
  final int typeId = 11;

  @override
  BusinessShippingAddressHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessShippingAddressHiveModel(
      fullName: fields[0] as String,
      phone: fields[1] as String,
      addressLine1: fields[2] as String,
      addressLine2: fields[3] as String?,
      city: fields[4] as String,
      state: fields[5] as String,
      postalCode: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessShippingAddressHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.fullName)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.addressLine1)
      ..writeByte(3)
      ..write(obj.addressLine2)
      ..writeByte(4)
      ..write(obj.city)
      ..writeByte(5)
      ..write(obj.state)
      ..writeByte(6)
      ..write(obj.postalCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessShippingAddressHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BusinessOrderHiveModelAdapter
    extends TypeAdapter<BusinessOrderHiveModel> {
  @override
  final int typeId = 12;

  @override
  BusinessOrderHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessOrderHiveModel(
      id: fields[0] as String?,
      userId: fields[1] as String,
      userFullName: fields[2] as String?,
      userEmail: fields[3] as String?,
      userPhone: fields[4] as String?,
      items: (fields[5] as List).cast<BusinessOrderItemHiveModel>(),
      shippingAddress: fields[6] as BusinessShippingAddressHiveModel,
      paymentMethod: fields[7] as String,
      paymentStatus: fields[8] as String,
      orderStatus: fields[9] as String,
      subtotal: fields[10] as double,
      shipping: fields[11] as double,
      tax: fields[12] as double,
      total: fields[13] as double,
      trackingNumber: fields[14] as String?,
      notes: fields[15] as String?,
      createdAt: fields[16] as DateTime?,
      updatedAt: fields[17] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessOrderHiveModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.userFullName)
      ..writeByte(3)
      ..write(obj.userEmail)
      ..writeByte(4)
      ..write(obj.userPhone)
      ..writeByte(5)
      ..write(obj.items)
      ..writeByte(6)
      ..write(obj.shippingAddress)
      ..writeByte(7)
      ..write(obj.paymentMethod)
      ..writeByte(8)
      ..write(obj.paymentStatus)
      ..writeByte(9)
      ..write(obj.orderStatus)
      ..writeByte(10)
      ..write(obj.subtotal)
      ..writeByte(11)
      ..write(obj.shipping)
      ..writeByte(12)
      ..write(obj.tax)
      ..writeByte(13)
      ..write(obj.total)
      ..writeByte(14)
      ..write(obj.trackingNumber)
      ..writeByte(15)
      ..write(obj.notes)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessOrderHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
