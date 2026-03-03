// lib/models/auth_models.dart

class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? address;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
    };
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final String? token;
  final UserInfo? user;

  AuthResponse({
    required this.success,
    required this.message,
    this.token,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
      user: json['user'] != null ? UserInfo.fromJson(json['user']) : null,
    );
  }
}

class UserInfo {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final List<String> roles;

  UserInfo({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    required this.roles,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      roles: List<String>.from(json['roles'] ?? []),
    );
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}