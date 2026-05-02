import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';
import '../../domain/usecases/manage_categories.dart';

part 'category_state.dart';

/// Manages category list and CRUD operations.
class CategoryCubit extends Cubit<CategoryState> {
  final ManageCategories _manageCategories;
  StreamSubscription<List<Category>>? _subscription;

  CategoryCubit(this._manageCategories) : super(const CategoryLoading()) {
    _subscribe();
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = _manageCategories.watchAll().listen(
      (categories) => emit(CategoryLoaded(categories)),
      onError: (e) => emit(CategoryError(e.toString())),
    );
  }

  Future<void> createCategory({
    required String name,
    required int color,
    required String icon,
    bool isUnnecessary = false,
  }) async {
    final result = await _manageCategories.create(
      name: name,
      color: color,
      icon: icon,
      isUnnecessary: isUnnecessary,
    );
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (_) {}, // Stream will auto-update
    );
  }

  Future<void> updateCategory(Category category) async {
    final result = await _manageCategories.update(category);
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (_) {},
    );
  }

  Future<void> deleteCategory(String id) async {
    final result = await _manageCategories.delete(id);
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (_) {},
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
