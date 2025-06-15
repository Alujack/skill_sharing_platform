// lib/core/api/config.dart
class ApiConfig {
  // Base configuration
  static const String baseUrl = 'http://localhost:4000/v1';
  static const int connectTimeout = 5000; // 5 seconds
  static const int receiveTimeout = 3000; // 3 seconds

  // Endpoint paths
  static const String courses = '/courses';
  static const String users = '/users';
  static const String auth = '/auth';
  // Add more resource paths as needed

  // Courses endpoints
  static String get allCourses => courses;
  static String courseById(int id) => '$courses/$id';
  static String instructorCourses(int instructorId) => '$courses/instructor/$instructorId';
  static String searchCourses(String query) => '$courses?search=$query';

  // Auth endpoints
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String refreshToken = '$auth/refresh';

  // Users endpoints
  static String userProfile(int userId) => '$users/$userId/profile';
  // Add more user-related endpoints

  // Headers configuration
  static Map<String, String> headers({String? token, String? contentType = 'application/json'}) {
    final headers = <String, String>{
      'Accept': 'application/json',
      if (contentType != null) 'Content-Type': contentType,
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  // File upload headers
  static Map<String, String> multipartHeaders({String? token}) {
    return {
      'Accept': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }

  // Helper to build full URLs
  static Uri buildUrl(String endpoint, {Map<String, dynamic>? queryParams}) {
    return Uri.parse(baseUrl + endpoint).replace(
      queryParameters: queryParams?.map((key, value) => 
        MapEntry(key, value.toString())),
    );
  }
}