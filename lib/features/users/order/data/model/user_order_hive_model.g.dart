// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_order_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserOrderItemHiveModelAdapter
    extends TypeAdapter<UserOrderItemHiveModel> {
  @override
  final int typeId = 16;

  @override
  UserOrderItemHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserOrderItemHiveModel(
      id: fields[0] as String?,
      productId: fields[1] as String,
      productName: fields[2] as String,
      price: fields[3] as double,
      discount: fields[4] as double,
      quantity: fields[5] as int,
      businessId: fields[6] as String,
      businessName: fields[7] as String?,
      image: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserOrderItemHiveModel obj) {
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
      other is UserOrderItemHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserOrderShippingAddressHiveModelAdapter
    extends TypeAdapter<UserOrderShippingAddressHiveModel> {
  @override
  final int typeId = 17;

  @override
  UserOrderShippingAddressHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserOrderShippingAddressHiveModel(
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
  void write(BinaryWriter writer, UserOrderShippingAddressHiveModel obj) {
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
      other is UserOrderShippingAddressHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserOrderHiveModelAdapter extends TypeAdapter<UserOrderHiveModel> {
  @override
  final int typeId = 18;

  @override
  UserOrderHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserOrderHiveModel(
      id: fields[0] as String?,
      userId: fields[1] as String,
      items: (fields[2] as List).cast<UserOrderItemHiveModel>(),
      shippingAddress: fields[3] as UserOrderShippingAddressHiveModel,
      paymentMethod: fields[4] as String,
      paymentStatus: fields[5] as String,
      orderStatus: fields[6] as String,
      subtotal: fields[7] as double,
      shipping: fields[8] as double,
      tax: fields[9] as double,
      total: fields[10] as double,
      trackingNumber: fields[11] as String?,
      notes: fields[12] as String?,
      createdAt: fields[13] as DateTime?,
      updatedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserOrderHiveModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.shippingAddress)
      ..writeByte(4)
      ..write(obj.paymentMethod)
      ..writeByte(5)
      ..write(obj.paymentStatus)
      ..writeByte(6)
      ..write(obj.orderStatus)
      ..writeByte(7)
      ..write(obj.subtotal)
      ..writeByte(8)
      ..write(obj.shipping)
      ..writeByte(9)
      ..write(obj.tax)
      ..writeByte(10)
      ..write(obj.total)
      ..writeByte(11)
      ..write(obj.trackingNumber)
      ..writeByte(12)
      ..write(obj.notes)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserOrderHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
