// lib/constants/app_constants.dart

class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://192.168.1.37:4000';
  static const String apiVersion = 'v1';
  static const String apiPrefix = '$baseUrl/$apiVersion';

  // API Endpoints
  static const String authEndpoint = '$apiPrefix/auth';
  static const String coursesEndpoint = '$apiPrefix/courses';
  static const String enrollmentsEndpoint = '$apiPrefix/enrollments';
  static const String instructorEndpoint = '$apiPrefix/instructor';
  static const String studentEndpoint = '$apiPrefix/student';
  static const String usersEndpoint = '$apiPrefix/users';
  static const String dashboardEndpoint = '$apiPrefix/dashboard';
  static const String categoriesEndpoint = '$apiPrefix/categories';
  static const String lessonEndpoint = '$apiPrefix/lesson';
  static const String wishlistEndpoint = '$apiPrefix/wishlist';

  // Auth Endpoints
  static String loginEndpoint = '$authEndpoint/login';
  static String registerEndpoint = '$authEndpoint/register';
  static String refreshTokenEndpoint = '$authEndpoint/refresh-token';
  static String forgotPasswordEndpoint = '$authEndpoint/forgot-password';
  static String resetPasswordEndpoint = '$authEndpoint/reset-password';
  static String getCurrentUser = '$authEndpoint/me';

  // Other constants
  static const String appName = 'Skill Sharing platform';
  static const String appVersion = '1.0.0';

  // API Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
}

// Environment configuration (alternative approach)
class Environment {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.123.192:4000',
  );

  static const String apiVersion = String.fromEnvironment(
    'API_VERSION',
    defaultValue: 'v1',
  );

  static String get apiPrefix => '$baseUrl/$apiVersion';
}
