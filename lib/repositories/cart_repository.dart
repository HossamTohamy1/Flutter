import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/cart_models.dart';

class CartRepository {
  // Get user cart
  Future<Cart> getUserCart(String userId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/Cart/user/$userId');

    final response = await http.get(
      url,
      headers: ApiConfig.headers,
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Cart.fromJson(data);
    } else {
      throw Exception('Failed to load cart: ${response.body}');
    }
  }

  // Add item to cart
  Future<CartItem> addToCart(String userId, int productId, int quantity) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/Cart/user/$userId/items');

    final response = await http.post(
      url,
      headers: ApiConfig.headers,
      body: json.encode({
        'productId': productId,
        'quantity': quantity,
      }),
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CartItem.fromJson(data);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to add to cart');
    }
  }

  // Update cart item quantity
  Future<CartItem> updateCartItem(String userId, int cartItemId, int quantity) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/Cart/user/$userId/items/$cartItemId');

    final response = await http.put(
      url,
      headers: ApiConfig.headers,
      body: json.encode({
        'quantity': quantity,
      }),
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CartItem.fromJson(data);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to update cart item');
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String userId, int cartItemId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/Cart/user/$userId/items/$cartItemId');

    final response = await http.delete(
      url,
      headers: ApiConfig.headers,
    ).timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to remove from cart');
    }
  }

  // Clear cart
  Future<void> clearCart(String userId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/Cart/user/$userId/clear');

    final response = await http.delete(
      url,
      headers: ApiConfig.headers,
    ).timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to clear cart');
    }
  }
}