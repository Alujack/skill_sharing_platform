import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:skill_sharing_platform/constants/app_constant.dart';
import 'package:skill_sharing_platform/exceptions/api_exception.dart';
import 'package:skill_sharing_platform/models/user_model.dart';
import 'package:skill_sharing_platform/auth_provider.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';

  // Login with email and password
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.loginEndpoint),
        headers: AppConstants.defaultHeaders,
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Extract token and user data from response
        final token = responseData['data']['token'];
        final userData = responseData['data']['user'];
        
        // Save to secure storage
        await _storage.write(key: _tokenKey, value: token);
        await _storage.write(key: _userKey, value: jsonEncode(userData));

        return {
          'statusCode': response.statusCode,
          'token': token,
          'user': userData,
        };
      } else {
        throw ApiException(
            responseData['message'] ?? 'Login failed', 
            response.statusCode, 
            response.body
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Login error: ${e.toString()}', 0);
    }
  }

  // Register new user
  static Future<Map<String, dynamic>> register(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.registerEndpoint),
        headers: AppConstants.defaultHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // If registration includes auto-login, save token and user data
        if (responseData['token'] != null) {
          await _storage.write(key: _tokenKey, value: responseData['token']);
        }
        if (responseData['user'] != null) {
          await _storage.write(
              key: _userKey, 
              value: jsonEncode(responseData['user'])
          );
        }

        return responseData;
      } else {
        throw ApiException(
            responseData['message'] ?? 'Registration failed',
            response.statusCode,
            response.body
        );
      }
    } catch (e) {
      throw ApiException('Registration error: ${e.toString()}', 0);
    }
  }

  // Logout user
  static Future<void> logout(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();
      
      // Clear secure storage
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
    } catch (e) {
      // Ensure storage is cleared even if logout fails
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
      throw ApiException('Logout error: ${e.toString()}', 0);
    }
  }

  // Get current user from API
  static Future<UserModel> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) throw ApiException('No authentication token', 401);

      final response = await http.get(
        Uri.parse(AppConstants.getCurrentUser),
        headers: {
          ...AppConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        await _storage.write(key: _userKey, value: jsonEncode(userData));
        return UserModel.fromJson(userData);
      } else {
        throw ApiException(
            'Failed to get user', 
            response.statusCode, 
            response.body
        );
      }
    } catch (e) {
      throw ApiException('Get user error: ${e.toString()}', 0);
    }
  }

  // Get stored token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Get stored user data
  static Future<UserModel?> getStoredUser() async {
    final userString = await _storage.read(key: _userKey);
    if (userString != null) {
      return UserModel.fromJson(jsonDecode(userString));
    }
    return null;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      // Verify token is still valid by fetching user data
      await getCurrentUser();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Initialize auth state
  static Future<void> initializeAuth(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = await getToken();
      final user = await getStoredUser();

      if (token != null && user != null) {
        authProvider.login(token, user);
      }
    } catch (e) {
      // Clear invalid auth data
      await clearAuthData();
    }
  }

  // Clear all auth data
  static Future<void> clearAuthData() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}