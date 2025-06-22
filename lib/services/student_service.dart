import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skill_sharing_platform/constants/app_constant.dart';

class StudentService {
  static Future<List<dynamic>> getStudentEnrollments(String studentId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.studentEndpoint}/learning/$studentId'),
        headers: AppConstants.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error fetching student enrollments: $e');
    }
  }

  static Future<List<dynamic>> getStudentCourses(String studentId) async {
    try {
      final enrollments = await getStudentEnrollments(studentId);
      return enrollments.map((enrollment) => enrollment['course']).toList();
    } catch (e) {
      throw Exception('Error fetching student courses: $e');
    }
  }
}
