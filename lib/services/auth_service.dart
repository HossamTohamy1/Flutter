// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_models.dart';

class AuthService {
  // 🔥 غيّر الـ URL ده لـ IP جهازك أو السيرفر بتاعك
  static const String baseUrl = 'http://10.0.2.2:5021/api'; // للـ Android Emulator
  
  // static const String baseUrl = 'https://YOUR_IP:7242/api'; // للـ Physical Device

  // Register
Future<AuthResponse> register(RegisterRequest request) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/Auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        final authResponse = AuthResponse.fromJson(data);

        if (authResponse.success && authResponse.token != null) {
          await _saveToken(authResponse.token!);
        }

        return authResponse;
      } else {
        return AuthResponse(
          success: false,
          message: 'Server returned empty response',
        );
      }
    } else {
      // هنا هيتطبع body لو فيه خطأ 400
      print('Error ${response.statusCode}: ${response.body}');
      return AuthResponse(
        success: false,
        message: 'Server error ${response.statusCode}: ${response.body}',
      );
    }
  } catch (e) {
    return AuthResponse(
      success: false,
      message: 'Connection error: ${e.toString()}',
    );
  }
}


  // Login
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          final authResponse = AuthResponse.fromJson(data);

          if (authResponse.success && authResponse.token != null) {
            await _saveToken(authResponse.token!);
          }

          return authResponse;
        } else {
          return AuthResponse(
            success: false,
            message: 'Server returned empty response',
          );
        }
      } else {
        return AuthResponse(
          success: false,
          message: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  // Save Token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Get Token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
