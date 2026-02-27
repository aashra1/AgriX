// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_product_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProductHiveModelAdapter extends TypeAdapter<UserProductHiveModel> {
  @override
  final int typeId = 14;

  @override
  UserProductHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProductHiveModel(
      productId: fields[0] as String?,
      businessId: fields[1] as String,
      businessName: fields[2] as String?,
      name: fields[3] as String,
      categoryId: fields[4] as String,
      categoryName: fields[5] as String?,
      brand: fields[6] as String?,
      price: fields[7] as double,
      discount: fields[8] as double,
      stock: fields[9] as int,
      weight: fields[10] as double?,
      unitType: fields[11] as String?,
      shortDescription: fields[12] as String?,
      fullDescription: fields[13] as String?,
      image: fields[14] as String?,
      createdAt: fields[15] as DateTime?,
      updatedAt: fields[16] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProductHiveModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.businessId)
      ..writeByte(2)
      ..write(obj.businessName)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.categoryId)
      ..writeByte(5)
      ..write(obj.categoryName)
      ..writeByte(6)
      ..write(obj.brand)
      ..writeByte(7)
      ..write(obj.price)
      ..writeByte(8)
      ..write(obj.discount)
      ..writeByte(9)
      ..write(obj.stock)
      ..writeByte(10)
      ..write(obj.weight)
      ..writeByte(11)
      ..write(obj.unitType)
      ..writeByte(12)
      ..write(obj.shortDescription)
      ..writeByte(13)
      ..write(obj.fullDescription)
      ..writeByte(14)
      ..write(obj.image)
      ..writeByte(15)
      ..write(obj.createdAt)
      ..writeByte(16)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProductHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
