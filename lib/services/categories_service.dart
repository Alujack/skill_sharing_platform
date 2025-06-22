import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skill_sharing_platform/constants/app_constant.dart';

class CategoriesService {
  static Future<List<dynamic>> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse(AppConstants.categoriesEndpoint),
        headers: AppConstants.defaultHeaders,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load course');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
