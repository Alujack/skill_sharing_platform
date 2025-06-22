// providers/auth_provider.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skill_sharing_platform/models/user_model.dart';
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
      // Simulate some delay for demonstration (remove in production)
      await Future.delayed(Duration(milliseconds: 500));
      
      _token = await const FlutterSecureStorage().read(key: 'auth_token');
      final userString = await const FlutterSecureStorage().read(key: 'user_data');
      
      if (userString != null) {
        _user = UserModel.fromJson(jsonDecode(userString));
      }
    } catch (e) {
      print("Initialization error: $e");
      // Clear invalid credentials
      await logout();
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> login(String token, UserModel user) async {
    _token = token;
    _user = user;
    await const FlutterSecureStorage().write(key: 'auth_token', value: token);
    await const FlutterSecureStorage().write(
      key: 'user_data', 
      value: jsonEncode(user.toJson())
    );
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await const FlutterSecureStorage().delete(key: 'auth_token');
    await const FlutterSecureStorage().delete(key: 'user_data');
    notifyListeners();
  }
}