// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 3;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      category: fields[1] as Category?,
      account: fields[2] as Account?,
      amount: fields[3] as double?,
      timestamp: fields[4] as int?,
      description: fields[5] as String?,
      accountKey: fields[6] as int?,
      categoryKey: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.account)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.accountKey)
      ..writeByte(7)
      ..write(obj.categoryKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
