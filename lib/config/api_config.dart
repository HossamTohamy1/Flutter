class ApiConfig {
  // ✅ Base URL for your API
  static const String baseUrl = 'http://10.0.2.2:5021'; // Android Emulator
  // static const String baseUrl = 'http://localhost:5021'; // iOS Simulator
  // static const String baseUrl = 'http://YOUR_IP:5021'; // Real Device

  // ✅ API Endpoints
  static const String categoriesEndpoint = '$baseUrl/api/Categories';
  static const String productsEndpoint = '$baseUrl/api/Products';
  static const String authEndpoint = '$baseUrl/api/Auth';
  
  // ✅ Image URL configuration
  static const String imageBaseUrl = '$baseUrl/images'; // If images are served from API

  // ✅ Request timeout duration
  static const Duration timeout = Duration(seconds: 30);

  // ✅ Common headers
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // ✅ Headers with authentication token
  static Map<String, String> headersWithAuth(String token) => {
        ...headers,
        'Authorization': 'Bearer $token',
      };

  // ✅ Helper method to get full image URL
  static String getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }

    // If already full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // If relative path, prepend base URL
    return '$imageBaseUrl/$imagePath';
  }
}
