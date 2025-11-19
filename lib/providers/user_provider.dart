import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  List<Order> _orders = [];
  bool _isAuthenticated = false;
  bool _isLoading = false;

  User? get user => _user;
  List<Order> get orders => _orders;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Set dummy user
      _user = dummyUser;
      _orders = dummyOrders;
      _isAuthenticated = true;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create new user
      _user = User(
        id: 1,
        name: name,
        email: email,
        phone: phone,
        joinedDate: DateTime.now(),
      );
      _orders = [];
      _isAuthenticated = true;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? avatar,
  }) async {
    if (_user == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Update user
      _user = User(
        id: _user!.id,
        name: name ?? _user!.name,
        email: email ?? _user!.email,
        phone: phone ?? _user!.phone,
        address: address ?? _user!.address,
        city: city ?? _user!.city,
        country: country ?? _user!.country,
        avatar: avatar ?? _user!.avatar,
        joinedDate: _user!.joinedDate,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Add order
  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  // Get order by ID
  Order? getOrder(int orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Logout
  void logout() {
    _user = null;
    _orders = [];
    _isAuthenticated = false;
    notifyListeners();
  }
}