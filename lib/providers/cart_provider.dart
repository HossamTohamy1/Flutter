import 'package:flutter/material.dart';
import '../models/cart_models.dart';
import '../repositories/cart_repository.dart';

class CartProvider with ChangeNotifier {
  final CartRepository _repository;
  
  Cart? _cart;
  bool _isLoading = false;
  String? _errorMessage;

  CartProvider(this._repository);

  // Getters
  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get itemCount => _cart?.totalItems ?? 0;
  double get totalAmount => _cart?.subTotal ?? 0.0;

  // Load cart
  Future<void> loadCart(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cart = await _repository.getUserCart(userId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _cart = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add to cart
  Future<bool> addToCart(String userId, int productId, int quantity) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.addToCart(userId, productId, quantity);
      await loadCart(userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update cart item
  Future<bool> updateCartItem(String userId, int cartItemId, int quantity) async {
    try {
      await _repository.updateCartItem(userId, cartItemId, quantity);
      await loadCart(userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Remove from cart
  Future<bool> removeFromCart(String userId, int cartItemId) async {
    try {
      await _repository.removeFromCart(userId, cartItemId);
      await loadCart(userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Clear cart
  Future<bool> clearCart(String userId) async {
    try {
      await _repository.clearCart(userId);
      _cart = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}