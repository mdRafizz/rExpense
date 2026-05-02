import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';
import '../../domain/usecases/manage_categories.dart';
import '../../core/logger/app_logger.dart';

part 'category_state.dart';

/// Manages category list and CRUD operations.
class CategoryCubit extends Cubit<CategoryState> {
  static const _tag = 'CategoryCubit';

  final ManageCategories _manageCategories;
  StreamSubscription<List<Category>>? _subscription;

  CategoryCubit(this._manageCategories) : super(const CategoryLoading()) {
    AppLogger.d(_tag, 'created — subscribing to category stream');
    _subscribe();
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = _manageCategories.watchAll().listen(
      (categories) {
        AppLogger.v(_tag, 'stream emitted ${categories.length} categories');
        emit(CategoryLoaded(categories));
      },
      onError: (e, st) {
        AppLogger.e(_tag, 'category stream error', error: e, stackTrace: st);
        emit(CategoryError(e.toString()));
      },
    );
  }

  Future<void> createCategory({
    required String name,
    required int color,
    required String icon,
    bool isUnnecessary = false,
  }) async {
    AppLogger.i(_tag, 'createCategory() name="$name" unnecessary=$isUnnecessary');
    final result = await _manageCategories.create(
      name: name,
      color: color,
      icon: icon,
      isUnnecessary: isUnnecessary,
    );
    result.fold(
      (failure) {
        AppLogger.e(_tag, 'createCategory() failed → ${failure.message}');
        emit(CategoryError(failure.message));
      },
      (_) => AppLogger.i(_tag, 'createCategory() success — stream will update'),
    );
  }

  Future<void> updateCategory(Category category) async {
    AppLogger.i(_tag, 'updateCategory() id=${category.id} name="${category.name}"');
    final result = await _manageCategories.update(category);
    result.fold(
      (failure) {
        AppLogger.e(_tag, 'updateCategory() failed → ${failure.message}');
        emit(CategoryError(failure.message));
      },
      (_) => AppLogger.i(_tag, 'updateCategory() success — stream will update'),
    );
  }

  Future<void> deleteCategory(String id) async {
    AppLogger.i(_tag, 'deleteCategory() id=$id');
    final result = await _manageCategories.delete(id);
    result.fold(
      (failure) {
        AppLogger.e(_tag, 'deleteCategory() failed → ${failure.message}');
        emit(CategoryError(failure.message));
      },
      (_) => AppLogger.i(_tag, 'deleteCategory() success — stream will update'),
    );
  }

  @override
  Future<void> close() {
    AppLogger.d(_tag, 'close() — cancelling subscription');
    _subscription?.cancel();
    return super.close();
  }
}
