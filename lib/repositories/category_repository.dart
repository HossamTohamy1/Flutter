import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../config/api_config.dart';

class CategoryRepository {
  // Get all categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await http
          .get(
            Uri.parse(ApiConfig.categoriesEndpoint),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Get category by ID
  Future<Category> getCategoryById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.categoriesEndpoint}/$id'),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return Category.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Category not found');
      } else {
        throw Exception('Failed to load category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching category: $e');
    }
  }

  // Create new category
  Future<Category> createCategory(CreateCategoryRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.categoriesEndpoint),
            headers: ApiConfig.headers,
            body: json.encode(request.toJson()),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 201) {
        return Category.fromJson(json.decode(response.body));
      } else if (response.statusCode == 400) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Bad request');
      } else {
        throw Exception('Failed to create category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }

  // Update category
  Future<void> updateCategory(int id, UpdateCategoryRequest request) async {
    try {
      final response = await http
          .put(
            Uri.parse('${ApiConfig.categoriesEndpoint}/$id'),
            headers: ApiConfig.headers,
            body: json.encode(request.toJson()),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Category not found');
      } else if (response.statusCode == 400) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Bad request');
      } else {
        throw Exception('Failed to update category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  // Delete category
  Future<void> deleteCategory(int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${ApiConfig.categoriesEndpoint}/$id'),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Category not found');
      } else if (response.statusCode == 400) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Cannot delete category with products');
      } else {
        throw Exception('Failed to delete category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }
}