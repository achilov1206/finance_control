import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 1)
class Account extends HiveObject {
  @HiveField(0)
  final String? title;
  @HiveField(1)
  final Map<String, dynamic>? icon;
  @HiveField(2)
  final double? balance;
  @HiveField(3)
  final String? description;

  Account({
    this.title,
    this.icon,
    this.balance,
    this.description,
  });
}
