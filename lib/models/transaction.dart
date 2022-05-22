import 'package:finance2/models/account.dart';
import 'package:finance2/models/category.dart';
import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 3)
class Transaction extends HiveObject {
  @HiveField(1)
  final Category? category;
  @HiveField(2)
  final Account? account;
  @HiveField(3)
  final double? amount;
  @HiveField(4)
  final int? timestamp;
  @HiveField(5)
  final String? description;

  Transaction({
    this.category,
    this.account,
    this.amount,
    this.timestamp,
    this.description,
  });
}
