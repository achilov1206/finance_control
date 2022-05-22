import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 4)
enum CategoryType {
  @HiveField(0)
  expense,
  @HiveField(1)
  income
}

@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(0)
  final String? title;
  @HiveField(1)
  final Map<String, dynamic>? icon;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final CategoryType? categoryType;

  Category({
    this.title,
    this.icon,
    this.description,
    this.categoryType,
  });
}
