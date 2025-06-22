import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skill_sharing_platform/constants/app_constant.dart';

class LessonService {
  // Get all lessons
  static Future<dynamic> getAllLessons() async {
    try {
      final response = await http.get(
        Uri.parse(AppConstants.lessonEndpoint),
        headers: AppConstants.defaultHeaders,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<dynamic> getLessonsByCourse(String courseId) async {
    try {
      final response = await http.get(
        Uri.parse("${AppConstants.lessonEndpoint}/course/$courseId"),
        headers: AppConstants.defaultHeaders,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<dynamic> getLessonById(String lessonId) async {
    try {
      final response = await http.get(
        Uri.parse("${AppConstants.lessonEndpoint}/$lessonId"),
        headers: AppConstants.defaultHeaders,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<dynamic> createLesson(dynamic lessonData) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.lessonEndpoint),
        headers: AppConstants.defaultHeaders,
        body: jsonEncode(lessonData),
      );
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<dynamic> updateLesson(String lessonId, dynamic lessonData) async {
    try {
      final response = await http.put(
        Uri.parse("${AppConstants.lessonEndpoint}/$lessonId"),
        headers: AppConstants.defaultHeaders,
        body: jsonEncode(lessonData),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<bool> deleteLesson(String lessonId) async {
    try {
      final response = await http.delete(
        Uri.parse("${AppConstants.lessonEndpoint}/$lessonId"),
        headers: AppConstants.defaultHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}