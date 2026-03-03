import 'package:flutter/foundation.dart';

// Dummy User Model
class User {
  final String id; // ✅ Changed from int to String
  final String name;
  final String email;
  final String phone;
  final String? address;
  final String? city;
  final String? country;
  final String? avatar;
  final DateTime joinedDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.city,
    this.country,
    this.avatar,
    required this.joinedDate,
  });
}

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  // Getters
  User? get user => _user;
  String? get userId => _user?.id; // ✅ Now returns String?
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  // Initialize with dummy user (for testing)
  void initializeDummyUser() {
    _user = User(
      id: '1', // ✅ String ID
      name: 'Test User',
      email: 'test@example.com',
      phone: '+1234567890',
      address: '123 Main Street',
      city: 'Cairo',
      country: 'Egypt',
      joinedDate: DateTime.now(),
    );
    _isAuthenticated = true;
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      _user = User(
        id: '1', // ✅ String ID
        name: 'John Doe',
        email: email,
        phone: '+1234567890',
        joinedDate: DateTime.now(),
      );
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
      await Future.delayed(const Duration(seconds: 2));

      _user = User(
        id: '1', // ✅ String ID
        name: name,
        email: email,
        phone: phone,
        joinedDate: DateTime.now(),
      );
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
      await Future.delayed(const Duration(seconds: 2));

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

  // Logout
  void logout() {
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}