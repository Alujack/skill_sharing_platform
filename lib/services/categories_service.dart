import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/app_constant.dart';

class CategoriesService {
  static Future<List<dynamic>> getAllCategories() async {
    print("i reach here ${Uri.parse(AppConstants.categoriesEndpoint)}");
    try {
      final response = await http.get(
        Uri.parse(AppConstants.categoriesEndpoint),
        headers: AppConstants.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Example: Get category by ID
  static Future<dynamic> getCategoryById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.categoriesEndpoint}/$id/course'),
        headers: AppConstants.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load category');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
