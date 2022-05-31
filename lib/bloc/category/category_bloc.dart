import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finance2/services/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/custom_error.dart';
import '../../models/category.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryService _categoryService;
  CategoryBloc(
    this._categoryService,
  ) : super(CategoryState.initial()) {
    on<LoadCategoriesEvent>((event, emit) {
      emit(state.copyWith(categoryStatus: CategoryStatus.loading));
      try {
        Map<dynamic, Category> categories = _categoryService.getCategories();
        emit(state.copyWith(
          categories: categories,
          categoryStatus: CategoryStatus.loaded,
        ));
      } catch (e) {
        emit(state.copyWith(
          categoryStatus: CategoryStatus.error,
          error: CustomError(
              message: e.toString(),
              plugin: 'categoryBloc/loadCategoriesEvent'),
        ));
      }
    });

    on<CreateCategoryEvent>((event, emit) {
      try {
        _categoryService.addCategory(event.newCategory);
        add(LoadCategoriesEvent());
      } catch (e) {
        print(e.toString());
      }
    });
    on<UpdateCategoryEvent>((event, emit) {
      try {
        _categoryService.updateCategory(event.key, event.newCategory);
        add(LoadCategoriesEvent());
      } catch (e) {
        print(e.toString());
      }
    });
    on<RemoveCategoryEvent>((event, emit) {
      try {
        _categoryService.removeCategory(event.key);
        add(LoadCategoriesEvent());
      } catch (e) {
        print(e.toString());
      }
    });
  }
}
