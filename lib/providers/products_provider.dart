import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/models/product_model.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // ⭐ Favorites now generated dynamically
  List<Product> get favoriteProducts =>
      _products.where((p) => p.isFavorite).toList();

  // Get filtered products
  List<Product> get filteredProducts {
    List<Product> filtered = _products;

    if (_selectedCategory != 'All') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  // Get categories
  List<String> get categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    cats.insert(0, 'All');
    return cats;
  }

  // Load products
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Load dummy products
      _products = DummyProducts.products;

    } catch (e) {}

    _isLoading = false;
    notifyListeners();
  }

  // Set category
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ⭐ Toggle favorite — بسيط وصحيح
  void toggleFavorite(int productId) {
    final index = _products.indexWhere((p) => p.id == productId);

    if (index >= 0) {
      _products[index].isFavorite = !_products[index].isFavorite;
      notifyListeners();
    }
  }

  // Check if product is favorite
  bool isFavorite(int productId) {
    return _products.any((p) => p.id == productId && p.isFavorite);
  }

  // Get product by ID
  Product? getProduct(int productId) {
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }
}
