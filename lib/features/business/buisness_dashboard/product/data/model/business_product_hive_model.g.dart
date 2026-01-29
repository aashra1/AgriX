// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_product_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductHiveModelAdapter extends TypeAdapter<ProductHiveModel> {
  @override
  final int typeId = 3;

  @override
  ProductHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductHiveModel(
      productId: fields[0] as String?,
      businessId: fields[1] as String,
      name: fields[2] as String,
      categoryId: fields[3] as String,
      categoryName: fields[4] as String?,
      brand: fields[5] as String?,
      price: fields[6] as double,
      discount: fields[7] as double,
      stock: fields[8] as int,
      weight: fields[9] as double?,
      unitType: fields[10] as String?,
      shortDescription: fields[11] as String?,
      fullDescription: fields[12] as String?,
      image: fields[13] as String?,
      createdAt: fields[14] as DateTime?,
      updatedAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductHiveModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.businessId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.categoryName)
      ..writeByte(5)
      ..write(obj.brand)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.discount)
      ..writeByte(8)
      ..write(obj.stock)
      ..writeByte(9)
      ..write(obj.weight)
      ..writeByte(10)
      ..write(obj.unitType)
      ..writeByte(11)
      ..write(obj.shortDescription)
      ..writeByte(12)
      ..write(obj.fullDescription)
      ..writeByte(13)
      ..write(obj.image)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
