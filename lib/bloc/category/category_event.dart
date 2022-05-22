part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategoriesEvent extends CategoryEvent {}

class CreateCategoryEvent extends CategoryEvent {
  final Category newCategory;
  const CreateCategoryEvent({
    required this.newCategory,
  });

  @override
  List<Object> get props => [newCategory];
}

class UpdateCategoryEvent extends CategoryEvent {
  final int key;
  final Category newCategory;
  const UpdateCategoryEvent({
    required this.key,
    required this.newCategory,
  });

  @override
  List<Object> get props => [key, newCategory];
}

class RemoveCategoryEvent extends CategoryEvent {
  final int key;
  const RemoveCategoryEvent({
    required this.key,
  });

  @override
  List<Object> get props => [key];
}
