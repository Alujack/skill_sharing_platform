import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skill_sharing_platform/constants/app_constant.dart';

class CoursesService {
  static Future<List<dynamic>> getAllCourses() async {
    try {
      final response = await http.get(
        Uri.parse(AppConstants.coursesEndpoint),
        headers: AppConstants.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<dynamic>> getCourses({
    String search = '',
    Map<String, dynamic> filters = const {},
  }) async {
    try {
      final queryParams = <String, String>{};

      if (search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (filters['categoryId'] != null) {
        queryParams['categoryId'] = filters['categoryId'].toString();
      }

      if (filters['isApproved'] != null) {
        queryParams['isApproved'] = filters['isApproved'].toString();
      }

      if (filters['instructorId'] != null) {
        queryParams['instructorId'] = filters['instructorId'].toString();
      }

      final uri = Uri.parse(AppConstants.coursesEndpoint).replace(
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      final response = await http.get(
        uri,
        headers: AppConstants.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  static Future<List<dynamic>> searchCourses(String query) async {
    return getCourses(search: query);
  }

  static Future<dynamic> getCourseById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.coursesEndpoint}/$id'),
        headers: AppConstants.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load course');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<dynamic>> getInstructorCourses(int instructorId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.coursesEndpoint}/instructor/$instructorId'),
        headers: AppConstants.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load instructor courses');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<dynamic> createCourse(dynamic data) async {
    try {
      final response = await http.post(Uri.parse(AppConstants.coursesEndpoint),
          headers: AppConstants.defaultHeaders, body: jsonEncode(data));
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to enroll, status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
