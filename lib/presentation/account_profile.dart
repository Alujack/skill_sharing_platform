import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              radius: 30,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
            SizedBox(height: 16),
            // User Name
            Text(
              'Yoeurn Yan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            // User Email
            Text(
              'yeantouch12345@gmail.com',
              style: TextStyle(
                color: const Color.fromARGB(255, 102, 102, 102),
              ),
            ),
            SizedBox(height: 8),
            // Instructor View Switch
            GestureDetector(
              onTap: () {
                // Handle switch view action
              },
              child: Text(
                'Switch to instructor view',
                style: TextStyle(
                  color: const Color.fromARGB(255, 25, 1, 233),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
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
            TextButton(
              onPressed: () {
                // Handle sign out action
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

  // Option Item Builder
  Widget _buildOptionItem(String title) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.0,
      ),
      onTap: () {
        // Handle option tap
      },
    );
  }
}
