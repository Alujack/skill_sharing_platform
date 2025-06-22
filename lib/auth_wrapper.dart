import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_sharing_platform/presentation/initial.dart';
import 'package:skill_sharing_platform/presentation/instructor/initial_instructor.dart';
import 'package:skill_sharing_platform/presentation/screens/auth/login_screen.dart';
import 'package:skill_sharing_platform/auth_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            authProvider.initialize();
          });

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!authProvider.isAuthenticated || authProvider.user == null) {
          return const LoginScreen();
        }
        final role = authProvider.user!.role;

        if (role == 'User' || role == 'Student') {
          return const Core();
        } else if (role == 'Instructor') {
          return const InstructorCore(); 
        } else {
          return const Scaffold(
            body: Center(child: Text('Unknown role')),
          );
        }
      },
    );
  }
}
