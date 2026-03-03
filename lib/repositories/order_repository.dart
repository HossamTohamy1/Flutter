import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/order_models.dart';

class OrderRepository {
  // Create order from cart
  Future<Order> createOrder(String userId, String shippingAddress, String? paymentMethod) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/Order/user/$userId');

    final response = await http.post(
      url,
      headers: ApiConfig.headers,
      body: json.encode({
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod ?? 'Cash on Delivery',
      }),
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Order.fromJson(data);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to create order');
    }
  }

  // Get user orders
  Future<List<OrderSummary>> getUserOrders(String userId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/Order/user/$userId');

    final response = await http.get(
      url,
      headers: ApiConfig.headers,
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((order) => OrderSummary.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders: ${response.body}');
    }
  }

  // Get order details
  Future<Order> getOrderDetails(String userId, int orderId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/Order/user/$userId/$orderId');

    final response = await http.get(
      url,
      headers: ApiConfig.headers,
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Order.fromJson(data);
    } else {
      throw Exception('Failed to load order details: ${response.body}');
    }
  }

  // Update payment status
  Future<void> updatePaymentStatus(int orderId, String paymentStatus) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/Order/$orderId/payment');

    final response = await http.put(
      url,
      headers: ApiConfig.headers,
      body: json.encode({
        'paymentStatus': paymentStatus,
      }),
    ).timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to update payment status');
    }
  }
}