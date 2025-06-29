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
      print("hello ${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
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

  static Future<dynamic> createLesson({
    required String title,
    required int courseId,
    required String videoFilePath,
  }) async {
    try {
      print("title ==${title}");
      print("course ==${courseId}");
      print("video  ==${videoFilePath}");
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppConstants.lessonEndpoint}/upload"),
      );

      // Add form fields
      request.fields['title'] = title;
      request.fields['courseId'] = courseId.toString();

      // Add video file
      request.files
          .add(await http.MultipartFile.fromPath('video', videoFilePath));

      // Add headers if needed
      request.headers.addAll(AppConstants.defaultHeaders);

      // Send request
      var streamedResponse = await request.send();

      // Read response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        // You can decode error response here if needed
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<dynamic> updateLesson({
    required String title,
    required int lessonId,
    required String videoFilePath,
  }) async {
    try {
      print("id ==${title}");
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse("${AppConstants.lessonEndpoint}/$lessonId"),
      );

      // Add form fields
      request.fields['title'] = title;

      // Add video file
      request.files
          .add(await http.MultipartFile.fromPath('video', videoFilePath));

      // Add headers if needed
      request.headers.addAll(AppConstants.defaultHeaders);

      // Send request
      var streamedResponse = await request.send();

      // Read response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        // You can decode error response here if needed
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

/*
  static Future<dynamic> updateLesson(
      String lessonId, dynamic lessonData) async {
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
*/
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
