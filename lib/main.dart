import 'package:flutter/material.dart';
import 'package:skill_sharing_platform/presentation/initial.dart';
import 'package:skill_sharing_platform/presentation/screens/auth/login_screen.dart';
import 'package:skill_sharing_platform/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Sharing Platform',
      home: FutureBuilder<bool>(
        future: AuthService.getToken().then((token) => token != null),
        builder: (context, snapshot) {
          // If still checking, show loading
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          AuthService.getToken().then((token) {
            print("This is the token: $token"); // Now prints actual token
            // Do something with token here
          });

          // If has token, go to Core, else Login
          return snapshot.data == true ? const Core() : const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/core': (context) => const Core(),
      },
    );
  }
}
