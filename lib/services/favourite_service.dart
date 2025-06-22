import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skill_sharing_platform/constants/app_constant.dart';

class FavouriteService {
  static Future<dynamic> addtofavourite(String courseId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConstants.wishlistEndpoint}/students/$userId"),
        headers: AppConstants.defaultHeaders,
        body: jsonEncode({'courseId': courseId}),
      );
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<dynamic> getFavouriteCourse(String userId) async {
    try {
      final response = await http.get(
          Uri.parse("${AppConstants.wishlistEndpoint}/students/$userId"),
          headers: AppConstants.defaultHeaders);
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
}
