import 'package:flutter/material.dart';
import '../models/order_models.dart';
import '../repositories/order_repository.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _repository;
  
  List<OrderSummary> _orders = [];
  Order? _selectedOrder;
  bool _isLoading = false;
  String? _errorMessage;

  OrderProvider(this._repository);

  // Getters
  List<OrderSummary> get orders => _orders;
  Order? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Create order
  Future<Order?> createOrder(String userId, String shippingAddress, String? paymentMethod) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final order = await _repository.createOrder(userId, shippingAddress, paymentMethod);
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return order;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Load user orders
  Future<void> loadUserOrders(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _repository.getUserOrders(userId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _orders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load order details
  Future<void> loadOrderDetails(String userId, int orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedOrder = await _repository.getOrderDetails(userId, orderId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _selectedOrder = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update payment status
  Future<bool> updatePaymentStatus(int orderId, String paymentStatus) async {
    try {
      await _repository.updatePaymentStatus(orderId, paymentStatus);
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

  // Clear selected order
  void clearSelectedOrder() {
    _selectedOrder = null;
    notifyListeners();
  }
}