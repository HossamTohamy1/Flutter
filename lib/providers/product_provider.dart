import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;

  ProductProvider(this._repository);

  List<Product> _products = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Pagination properties
  int _currentPage = 1;
  int _pageSize = 10;
  int _totalCount = 0;
  int _totalPages = 0;
  
  // Filtering properties
  int? _selectedCategoryId;
  String? _searchTerm;

  // Getters
  List<Product> get products => _products;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalCount => _totalCount;
  int? get selectedCategoryId => _selectedCategoryId;
  String? get searchTerm => _searchTerm;

  // Fetch products with pagination and filtering
  Future<void> fetchProducts({
    int? page,
    int? pageSize,
    int? categoryId,
    String? search,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _products.clear();
    }
    
    if (page != null) _currentPage = page;
    if (pageSize != null) _pageSize = pageSize;
    if (categoryId != null) _selectedCategoryId = categoryId;
    if (search != null) _searchTerm = search;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pagedProducts = await _repository.getAllProducts(
        pageNumber: _currentPage,
        pageSize: _pageSize,
        categoryId: _selectedCategoryId,
        searchTerm: _searchTerm,
      );

      _products = pagedProducts.products;
      _totalCount = pagedProducts.totalCount;
      _totalPages = pagedProducts.totalPages;
      _currentPage = pagedProducts.pageNumber;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load next page
  Future<void> loadNextPage() async {
    if (_currentPage < _totalPages && !_isLoading) {
      await fetchProducts(page: _currentPage + 1);
    }
  }

  // Load previous page
  Future<void> loadPreviousPage() async {
    if (_currentPage > 1 && !_isLoading) {
      await fetchProducts(page: _currentPage - 1);
    }
  }

  // Filter by category
  Future<void> filterByCategory(int? categoryId) async {
    _selectedCategoryId = categoryId;
    await fetchProducts(page: 1, refresh: true);
  }

  // Search products
  Future<void> searchProducts(String search) async {
    _searchTerm = search;
    await fetchProducts(page: 1, refresh: true);
  }

  // Clear filters
  Future<void> clearFilters() async {
    _selectedCategoryId = null;
    _searchTerm = null;
    await fetchProducts(page: 1, refresh: true);
  }

  // Fetch single product by ID
  Future<void> fetchProductById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedProduct = await _repository.getProductById(id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _selectedProduct = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new product
  Future<bool> createProduct({
    required String productName,
    String? description,
    required double price,
    required int stock,
    int? categoryId,
    String? imageUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.createProduct(
        productName: productName,
        description: description,
        price: price,
        stock: stock,
        categoryId: categoryId,
        imageUrl: imageUrl,
      );
      
      // Refresh the list after creating
      await fetchProducts(refresh: true);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update existing product
  Future<bool> updateProduct({
    required int id,
    required String productName,
    String? description,
    required double price,
    required int stock,
    int? categoryId,
    String? imageUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateProduct(
        id: id,
        productName: productName,
        description: description,
        price: price,
        stock: stock,
        categoryId: categoryId,
        imageUrl: imageUrl,
      );
      
      // Refresh the list after updating
      await fetchProducts();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteProduct(id);
      
      // Refresh the list after deleting
      await fetchProducts();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }
}