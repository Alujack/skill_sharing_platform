// lib/features/course/data/services/course_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skill_sharing_platform/core/api/config.dart';
import 'package:skill_sharing_platform/data/models/course_model.dart';

class CourseService {
  final String? authToken;

  CourseService(this.authToken);

  Future<List<Course>> getAllCourses() async {
    final response = await http.get(
      ApiConfig.buildUrl(ApiConfig.allCourses),
      headers: ApiConfig.headers(token: authToken),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((course) => Course.fromJson(course)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<List<Course>> getInstructorCourses(int instructorId) async {
    final response = await http.get(
      ApiConfig.buildUrl(ApiConfig.instructorCourses(instructorId)),
      headers: ApiConfig.headers(token: authToken),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((course) => Course.fromJson(course)).toList();
    } else {
      throw Exception('Failed to load instructor courses');
    }
  }

  Future<Course> getCourseById(int id) async {
    final response = await http.get(
      ApiConfig.buildUrl(ApiConfig.courseById(id)),
      headers: ApiConfig.headers(token: authToken),
    );

    if (response.statusCode == 200) {
      return Course.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load course');
    }
  }

}