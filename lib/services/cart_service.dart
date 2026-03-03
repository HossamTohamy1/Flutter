import 'dart:convert';
import 'package:http/http.dart' as http;

class CartService {
  //static const String baseUrl = 'https://api.yourstore.com/api'; // غيّر الـ URL
    static const String baseUrl = 'http://10.0.2.2:5021/api'; // للـ Android Emulator

  // ============= GET: جلب السلة من السيرفر =============
  Future<Map<String, dynamic>> fetchCart(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cart/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN', // لو عندك Token
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ============= POST: إضافة منتج للسلة =============
  Future<Map<String, dynamic>> addToCart({
    required String userId,
    required int productId,
    required int quantity,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN',
        },
        body: json.encode({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add to cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ============= PUT: تحديث الكمية =============
  Future<Map<String, dynamic>> updateCartItem({
    required String userId,
    required int productId,
    required int quantity,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/cart/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN',
        },
        body: json.encode({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ============= DELETE: حذف منتج من السلة =============
  Future<void> removeFromCart({
    required String userId,
    required int productId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cart/remove'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN',
        },
        body: json.encode({
          'user_id': userId,
          'product_id': productId,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to remove from cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ============= DELETE: مسح السلة بالكامل =============
  Future<void> clearCart(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cart/clear/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to clear cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ============= POST: إتمام الطلب (Checkout) =============
  Future<Map<String, dynamic>> checkout({
    required String userId,
    required Map<String, dynamic> orderDetails,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN',
        },
        body: json.encode({
          'user_id': userId,
          ...orderDetails,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to checkout: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}