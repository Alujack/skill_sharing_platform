import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skill_sharing_platform/constants/app_constant.dart';

class CategoriesService {
  static Future<List<dynamic>> getAllCategories() async {
    print("category print ===");
    try {
      final response = await http.get(
        Uri.parse(AppConstants.categoriesEndpoint),
        headers: AppConstants.defaultHeaders,
      );
      final dataA = response.body;
      print("category print === ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("this is a data ====${data['data']}");
        return data['data'];
      } else {
        throw Exception('Failed to load course');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
