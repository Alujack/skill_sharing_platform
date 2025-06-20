import 'package:flutter/material.dart';
import 'package:skill_sharing_platform/presentation/screens/auth/login_screen.dart';
import 'package:skill_sharing_platform/presentation/screens/auth/signup_screen.dart';
import 'api_service.dart';
import './presentation/initial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      '/login': (context) => const LoginScreen(),
      '/signup': (context) => const SignupScreen(),
    }, initialRoute: '/login');
  }
}
