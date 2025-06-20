import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:skill_sharing_platform/api_service.dart';
import 'package:skill_sharing_platform/constants/app_constant.dart';
import 'package:skill_sharing_platform/exceptions/api_exception.dart' hide ApiException;

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    print("email == $email");
    print("password == $password");
    
    try {
      final response = await http.post(
        Uri.parse(AppConstants.login),
        headers: AppConstants.defaultHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      print("response == ${response.body}");
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException('Login failed', response.statusCode, response.body);
      }
    } catch (e) {
      throw ApiException('Login error: ${e.toString()}', 0);
    }
  }

  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.register),
        headers: AppConstants.defaultHeaders,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw ApiException('Registration failed', response.statusCode, response.body);
      }
    } catch (e) {
      throw ApiException('Registration error: ${e.toString()}', 0);
    }
  }

  static Future<void> logout(String token) async {
    try {
      final headers = {
        ...AppConstants.defaultHeaders,
        'Authorization': 'Bearer $token',
      };
      
      final response = await http.post(
        Uri.parse(AppConstants.logout),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw ApiException('Logout failed', response.statusCode, response.body);
      }
    } catch (e) {
      throw ApiException('Logout error: ${e.toString()}', 0);
    }
  }

  static Future<Map<String, dynamic>> getCurrentUser(String token) async {
    try {
      final headers = {
        ...AppConstants.defaultHeaders,
        'Authorization': 'Bearer $token',
      };
      
      final response = await http.get(
        Uri.parse(AppConstants.me),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException('Failed to get user', response.statusCode, response.body);
      }
    } catch (e) {
      throw ApiException('Get user error: ${e.toString()}', 0);
    }
  }
}