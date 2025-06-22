import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skill_sharing_platform/constants/app_constant.dart';

class EnrollmentService {
  static Future<dynamic> buyNowEnroll(String courseId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.enrollmentsEndpoint),
        headers: AppConstants.defaultHeaders,
        body: jsonEncode({'courseId': courseId, 'userId': userId}),
      );

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
