import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_sharing_platform/auth_provider.dart';
import 'package:skill_sharing_platform/widgets/become_instructor.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: user?.profileImage != null
                  ? NetworkImage(user!.profileImage!)
                  : AssetImage('assets/images/profile.jpg') as ImageProvider,
            ),
            SizedBox(height: 16),
            // User Name
            Text(
              user?.name ?? 'Guest',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            // User Email
            Text(
              user?.email ?? '',
              style: TextStyle(
                color: const Color.fromARGB(255, 102, 102, 102),
              ),
            ),
            SizedBox(height: 8),
            if (authProvider.isAuthenticated && user!.role != 'Instructor')
              GestureDetector(
                onTap: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) => BecomeInstructorDialog(
                      userId: user!.id,
                    ),
                  );
                },
                child: Text(
                  'Become an instructor',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 25, 1, 233),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // Options List
            Expanded(
              child: ListView(
                children: [
                  _buildOptionItem('Download options'),
                  _buildOptionItem('Video playback options'),
                  _buildOptionItem('Your downloaded courses'),
                  _buildOptionItem('Occupation and interests'),
                  _buildOptionItem('Privacy settings'),
                  _buildOptionItem('Notifications'),
                  _buildOptionItem('Language preferences'),
                  _buildOptionItem('Help and support'),
                ],
              ),
            ),
            // Sign Out Button
            if (authProvider.isAuthenticated)
              TextButton(
                onPressed: () {
                  authProvider.logout();
                  // Optionally navigate to login screen
                },
                child: Text(
                  'Sign out',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 25, 1, 233),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(String title) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () {
        // Handle option tap
      },
    );
  }
}
