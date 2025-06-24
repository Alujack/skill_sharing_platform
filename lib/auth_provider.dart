// providers/auth_provider.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skill_sharing_platform/models/user_model.dart';
import 'package:skill_sharing_platform/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  String? _token;
  bool _isInitialized = false;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));

      _token = await const FlutterSecureStorage().read(key: 'auth_token');
      final userString =
          await const FlutterSecureStorage().read(key: 'user_data');

      if (userString != null) {
        _user = UserModel.fromJson(jsonDecode(userString));
      }
    } catch (e) {
      await logout();
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      // Use AuthService to make the actual API call
      final result = await AuthService.login(email, password);

      _token = result['token'];
      _user = UserModel.fromJson(result['user']);

      await const FlutterSecureStorage()
          .write(key: 'auth_token', value: _token);
      await const FlutterSecureStorage()
          .write(key: 'user_data', value: jsonEncode(_user!.toJson()));

      notifyListeners();
    } catch (e) {
      // Handle errors
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await const FlutterSecureStorage().delete(key: 'auth_token');
    await const FlutterSecureStorage().delete(key: 'user_data');
    notifyListeners();
  }
}
