import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skill_sharing_platform/api_service.dart';
import 'package:skill_sharing_platform/constants/app_constant.dart';
import 'package:skill_sharing_platform/exceptions/api_exception.dart'
    hide ApiException;

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _userKey = 'current_user';

  // Login with email and password
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    print("Login attempt started for email: $email");

    try {
      final response = await http.post(
        Uri.parse(AppConstants.loginEndpoint),
        headers: AppConstants.defaultHeaders,
        body: jsonEncode({'email': email, 'password': password}),
      );

      print("Login response status: ${response.statusCode}");
      print("Login response body: ${response.body}");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Extract token from the nested data object
        final token = responseData['data']?['token'];

        if (token == null) {
          print("ERROR: Token not found in response data");
          throw ApiException(
              'Token not provided', response.statusCode, response.body);
        }

        print("Token received: $token");

        // Save token
        await _storage.write(key: _tokenKey, value: token);
        print("Token saved to secure storage");

        // Verify storage
        final savedToken = await _storage.read(key: _tokenKey);
        if (savedToken == token) {
          print("Token storage verified successfully");
        } else {
          print("ERROR: Token storage verification failed");
        }

        // Save user data if available
        if (responseData['data']?['user'] != null) {
          await _storage.write(
              key: _userKey, value: jsonEncode(responseData['data']['user']));
          print("User data saved");
        }

        return responseData;
      } else {
        // Handle API error responses
        final errorMessage = responseData['message'] ?? 'Login failed';
        throw ApiException(errorMessage, response.statusCode, response.body);
      }
    } catch (e) {
      print("Login error: ${e.toString()}");
      if (e is ApiException) rethrow;
      throw ApiException('Login error: ${e.toString()}', 0);
    }
  }

  // Register new user
  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.registerEndpoint),
        headers: AppConstants.defaultHeaders,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Save token and user data if registration includes auto-login
        if (responseData['token'] != null) {
          await _storage.write(key: _tokenKey, value: responseData['token']);
        }
        if (responseData['user'] != null) {
          await _storage.write(
              key: _userKey, value: jsonEncode(responseData['user']));
        }

        return responseData;
      } else {
        throw ApiException(
            'Registration failed', response.statusCode, response.body);
      }
    } catch (e) {
      throw ApiException('Registration error: ${e.toString()}', 0);
    }
  }

  // Logout user
  static Future<void> logout() async {
    try {
      final token = await getToken();
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
    } catch (e) {
      // Even if logout API fails, clear local storage
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
      throw ApiException('Logout error: ${e.toString()}', 0);
    }
  }

  // Get current user
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) throw ApiException('No authentication token', 401);

      final headers = {
        ...AppConstants.defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(AppConstants.getCurrentUser),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        // Update stored user data
        await _storage.write(key: _userKey, value: jsonEncode(userData));
        return userData;
      } else {
        throw ApiException(
            'Failed to get user', response.statusCode, response.body);
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
  static Future<Map<String, dynamic>?> getStoredUser() async {
    final userString = await _storage.read(key: _userKey);
    return userString != null ? jsonDecode(userString) : null;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;

    // Optional: Verify token with backend
    try {
      final user = await getCurrentUser();
      return user.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Clear all auth data (for logout or session expiration)
  static Future<void> clearAuthData() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}
