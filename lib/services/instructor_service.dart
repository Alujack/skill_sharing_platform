import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skill_sharing_platform/constants/app_constant.dart';

class InstructorService {
  static Future<dynamic> becomeInstructor(dynamic data) async {
    print("data ---$data");
    try {
      final response = await http.post(
        Uri.parse("${AppConstants.instructorEndpoint}/become-instructor"),
        headers: AppConstants.defaultHeaders,
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to request, status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
