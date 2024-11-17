import 'package:flutter/material.dart';
import '../widgets/bottom_bar.dart';
import 'home_page.dart';
import 'search_page.dart';

// Home Screen with Bottom Navigation Bar
class Core extends StatefulWidget {
  const Core({Key? key}) : super(key: key);

  @override
  State<Core> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Core> {
  int _currentIndex = 0;

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

  // Function to return the current page widget
  Widget getCurrentPage(int index) {
    switch (index) {
      case 0:
        return const FeaturedPage();
      case 1:
        return const SearchScreen();
      case 2:
        return const FeaturedPage();
      case 3:
        return const FeaturedPage();
      case 4:
        return const FeaturedPage();
      default:
        return const FeaturedPage();
    }
  }
}