// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_auth_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessAuthHiveModelAdapter extends TypeAdapter<BusinessAuthHiveModel> {
  @override
  final int typeId = 1;

  @override
  BusinessAuthHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessAuthHiveModel(
      businessId: fields[0] as String?,
      businessName: fields[1] as String,
      email: fields[2] as String,
      password: fields[3] as String,
      phoneNumber: fields[4] as String,
      address: fields[5] as String?,
      businessDocument: fields[6] as String?,
      businessStatus: fields[7] as String?,
      businessVerified: fields[8] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessAuthHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.businessId)
      ..writeByte(1)
      ..write(obj.businessName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.businessDocument)
      ..writeByte(7)
      ..write(obj.businessStatus)
      ..writeByte(8)
      ..write(obj.businessVerified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessAuthHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
