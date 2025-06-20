// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import './constants//app_constant.dart';

class ApiService {
  // Generic GET request
  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${AppConstants.baseUrl}/${AppConstants.apiVersion}/$endpoint'),
        headers: AppConstants.defaultHeaders,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Generic POST request
  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${AppConstants.baseUrl}/${AppConstants.apiVersion}/$endpoint'),
        headers: AppConstants.defaultHeaders,
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Add authentication token to headers
  static Map<String, String> getAuthHeaders(String token) {
    return {
      ...AppConstants.defaultHeaders,
      'Authorization': 'Bearer $token',
    };
  }
}
