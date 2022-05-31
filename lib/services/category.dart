import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/category.dart';
import '../utils/helpers.dart';

class CategoryService {
  late Box<Category> _categories;

  CategoryService() {
    init();
  }

  Future<void> init() async {
    _categories = Hive.box<Category>('categories');
    if (_categories.isEmpty) {
      Category salary = Category(
        title: 'Salary',
        categoryType: CategoryType.income,
        icon: Helpers.iconToCodeData(Icons.money_off),
        description: 'Monthly Salary',
      );
      Category food = Category(
        title: 'Foods',
        categoryType: CategoryType.expense,
        icon: Helpers.iconToCodeData(Icons.food_bank),
        description: 'Foods',
      );
      Category shopping = Category(
        title: 'Shopping',
        categoryType: CategoryType.expense,
        icon: Helpers.iconToCodeData(Icons.shopping_bag),
        description: 'Shopping',
      );
      await _categories.add(salary);
      await _categories.add(food);
      await _categories.add(shopping);
    }
  }

  Map<dynamic, Category> getCategories() {
    final categories = _categories.toMap();
    return categories;
  }

  Category? getCategory(int key) {
    return _categories.get(key);
  }

  void addCategory(Category newCategory) {
    _categories.add(newCategory);
  }

  Future<void> removeCategory(int key) async {
    await _categories.delete(key);
  }

  Future<void> updateCategory(int key, Category newCategory) async {
    await _categories.put(key, newCategory);
  }
}
