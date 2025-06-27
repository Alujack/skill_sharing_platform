import 'package:flutter/material.dart';
import '../widgets/bottom_bar.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'my_course.dart';
import './account_profile.dart';
import './favourite_page.dart';

class Core extends StatefulWidget {
  final int initialIndex;
  const Core({super.key, this.initialIndex = 0});

  @override
  State<Core> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Core> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getCurrentPage(_currentIndex),
      bottomNavigationBar: CustomBottomNavBar(
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
        return const SearchScreen();
      case 2:
        return const CourseScreen();
      case 3:
        return const FavouritePage();
      case 4:
        return const AccountPage();
      default:
        return const FeaturedPage();
    }
  }
}
