part of 'category_bloc.dart';

enum CategoryStatus { initial, loading, loaded, error }

class CategoryState extends Equatable {
  final Map<dynamic, Category> categories;
  final CategoryStatus categoryStatus;
  final CustomError error;
  const CategoryState({
    required this.categories,
    required this.categoryStatus,
    required this.error,
  });

  factory CategoryState.initial() {
    return const CategoryState(
      categories: {},
      categoryStatus: CategoryStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object> get props => [categories, categoryStatus, error];

  @override
  String toString() =>
      'CategoryState(categories: $categories, categoryStatus: $categoryStatus, customError: $error)';

  CategoryState copyWith({
    Map<dynamic, Category>? categories,
    CategoryStatus? categoryStatus,
    CustomError? error,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      categoryStatus: categoryStatus ?? this.categoryStatus,
      error: error ?? this.error,
    );
  }
}
