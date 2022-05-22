import 'package:hive/hive.dart';
import '../models/category.dart';

class CategoryService {
  late Box<Category> _categories;

  CategoryService() {
    init();
  }

  Future<void> init() async {
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(CategoryTypeAdapter());
    _categories = await Hive.openBox('categories');
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
    final index = key;
    await _categories.put(index, newCategory);
  }
}
