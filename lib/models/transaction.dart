import 'package:hive/hive.dart';
import '../models/account.dart';
import '../models/category.dart';
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
  @HiveField(6)
  final int? accountKey;
  @HiveField(7)
  final int? categoryKey;

  Transaction({
    this.category,
    this.account,
    this.amount,
    this.timestamp,
    this.description,
    this.accountKey,
    this.categoryKey,
  });
}
