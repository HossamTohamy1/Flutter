import 'package:flutter/foundation.dart';
import '../models/category_model.dart' as app_models;
import '../repositories/category_repository.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryRepository _repository;

  List<app_models.Category> _categories = [];
  app_models.Category? _selectedCategory;
  bool _isLoading = false;
  String? _errorMessage;

  CategoryProvider(this._repository);

  List<app_models.Category> get categories => _categories;
  app_models.Category? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Helpers
  void _startLoading() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  // Fetch all categories
  Future<void> fetchCategories() async {
    _startLoading();
    try {
      _categories = await _repository.getCategories();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _stopLoading();
  }

  // Fetch single category
  Future<void> fetchCategoryById(int id) async {
    _startLoading();
    try {
      _selectedCategory = await _repository.getCategoryById(id);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _stopLoading();
  }

  // Create category
  Future<bool> createCategory(app_models.CreateCategoryRequest request) async {
    _startLoading();
    try {
      final newCategory = await _repository.createCategory(request);
      _categories.add(newCategory);
      _stopLoading();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _stopLoading();
      return false;
    }
  }

  // Update category
  Future<bool> updateCategory(int id, app_models.UpdateCategoryRequest request) async {
    _startLoading();
    try {
      await _repository.updateCategory(id, request);

          final index = _categories.indexWhere((c) => c.categoryId == id);
          if (index != -1) {
            final old = _categories[index];
            _categories[index] = app_models.Category(
              categoryId: old.categoryId,
              categoryName: request.categoryName,
              description: request.description,
              createdAt: old.createdAt,
              productCount: old.productCount,
            );
          }


      _stopLoading();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _stopLoading();
      return false;
    }
  }

  // Delete category
  Future<bool> deleteCategory(int id) async {
    _startLoading();
    try {
      await _repository.deleteCategory(id);
      _categories.removeWhere((c) => c.categoryId == id);
      _stopLoading();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _stopLoading();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
