import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skill_sharing_platform/constants/app_constant.dart';

class CoursesService {
  static Future<List<dynamic>> getAllCourses() async {
    try {
      final response = await http.get(
        Uri.parse(AppConstants.courses),
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

  static Future<dynamic> getCourseById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.courses}/$id'),
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
        Uri.parse('${AppConstants.courses}/instructor/$instructorId'),
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
}
