// lib/core/api/api_versions.dart
abstract class ApiV1 {
  static const String baseUrl = 'http://your-api-url.com/v1';
  
  static class Courses {
    static const String base = '/courses';
    static String byId(int id) => '$base/$id';
    static String search(String query) => '$base?search=$query';
    static String instructor(int id) => '$base/instructor/$id';
  }
  
  static class Auth {
    static const String base = '/auth';
    static const String login = '$base/login';
    static const String register = '$base/register';
  }
}
