import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/product.dart';

class ProductRepository {
  Future<PagedProducts> getAllProducts({
    int pageNumber = 1,
    int pageSize = 10,
    int? categoryId,
    String? searchTerm,
  }) async {
    try {
      var uri = Uri.parse(ApiConfig.productsEndpoint);
      
      // Build query parameters
      final queryParams = <String, String>{
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
      };
      
      if (categoryId != null) {
        queryParams['categoryId'] = categoryId.toString();
      }
      
      if (searchTerm != null && searchTerm.isNotEmpty) {
        queryParams['searchTerm'] = searchTerm;
      }
      
      uri = uri.replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: ApiConfig.headers,
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PagedProducts.fromJson(data);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.productsEndpoint}/$id'),
        headers: ApiConfig.headers,
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  Future<Product> createProduct({
    required String productName,
    String? description,
    required double price,
    required int stock,
    int? categoryId,
    String? imageUrl,
  }) async {
    try {
      final body = {
        'productName': productName,
        'description': description,
        'price': price,
        'stock': stock,
        'categoryId': categoryId,
        'imageUrl': imageUrl,
      };

      final response = await http.post(
        Uri.parse(ApiConfig.productsEndpoint),
        headers: ApiConfig.headers,
        body: json.encode(body),
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to create product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }

  Future<Product> updateProduct({
    required int id,
    required String productName,
    String? description,
    required double price,
    required int stock,
    int? categoryId,
    String? imageUrl,
  }) async {
    try {
      final body = {
        'productName': productName,
        'description': description,
        'price': price,
        'stock': stock,
        'categoryId': categoryId,
        'imageUrl': imageUrl,
      };

      final response = await http.put(
        Uri.parse('${ApiConfig.productsEndpoint}/$id'),
        headers: ApiConfig.headers,
        body: json.encode(body),
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.productsEndpoint}/$id'),
        headers: ApiConfig.headers,
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }
}