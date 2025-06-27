import 'package:flutter/material.dart';
import 'package:skill_sharing_platform/presentation/home_page.dart';
import 'package:skill_sharing_platform/presentation//account_profile.dart';
import 'package:skill_sharing_platform/presentation/instructor/course_list_screen.dart';
import 'package:skill_sharing_platform/widgets/inctructor_button_bar.dart';

// Home Screen with Bottom Navigation Bar
class InstructorCore extends StatefulWidget {
  const InstructorCore({super.key});
  @override
  State<InstructorCore> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<InstructorCore> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getCurrentPage(_currentIndex),
      bottomNavigationBar: InstructorCustomBottomNavBar(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
  Widget getCurrentPage(int index) {
    switch (index) {
      case 0:
        return const FeaturedPage();
      case 1:
        return CourseListScreen();
      case 2:
        return const AccountPage();
      default:
        return const FeaturedPage();
    }
  }
}
