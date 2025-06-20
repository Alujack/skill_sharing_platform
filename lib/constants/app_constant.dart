// lib/constants/app_constants.dart

class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://192.168.123.192:4000';
  static const String apiVersion = 'v1';

  // API Endpoints
  static const String categoriesEndpoint = '$baseUrl/$apiVersion/categories';
  static const String coursesEndpoint = '$baseUrl/$apiVersion/courses';
  static const String usersEndpoint = '$baseUrl/$apiVersion/users';

  // Other constants
  static const String appName = 'Your App Name';
  static const String appVersion = '1.0.0';

  // API Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}

// Alternative approach - using environment variables
class Environment {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:3000', // fallback URL
  );
}
