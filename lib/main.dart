import 'package:flutter/material.dart';
import 'api_service.dart';
import './widgets/sigin_form.dart';
import './widgets/create_account.dart';
import './presentation/initial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService('https://fakestoreapi.com/products');

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Core(),
    );
  }
}
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: const HomeScreen(),
//     );
//   }
// }

// // Home Screen with Bottom Navigation Bar
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Bottom Navigation Bar'),
//       ),
//       body: getCurrentPage(_currentIndex),
//       bottomNavigationBar: CustomBottomNavBar(
//         currentIndex: _currentIndex,
//         onItemSelected: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//     );
//   }

//   // Function to return the current page widget
//   Widget getCurrentPage(int index) {
//     switch (index) {
//       case 0:
//         return const FeaturedPage();
//       case 1:
//         return const SearchPage();
//       case 2:
//         return const MyCoursePage();
//       case 3:
//         return const FavoritePage();
//       case 4:
//         return const AccountPage();
//       default:
//         return const FeaturedPage();
//     }
//   }
// }

// // Custom Bottom Navigation Bar Widget
// class CustomBottomNavBar extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onItemSelected;

//   const CustomBottomNavBar({
//     Key? key,
//     required this.currentIndex,
//     required this.onItemSelected,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       type: BottomNavigationBarType.fixed,
//       selectedItemColor: Colors.black,
//       unselectedItemColor: Colors.grey,
//       onTap: onItemSelected,
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.star),
//           label: 'Featured',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.search),
//           label: 'Search',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.video_collection),
//           label: 'My course',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.favorite),
//           label: 'Favorite',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.account_circle),
//           label: 'Account',
//         ),
//       ],
//     );
//   }
// }

// // Individual Page Widgets
// class FeaturedPage extends StatelessWidget {
//   const FeaturedPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Featured Page'),
//     );
//   }
// }

// class SearchPage extends StatelessWidget {
//   const SearchPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Search Page'),
//     );
//   }
// }

// class MyCoursePage extends StatelessWidget {
//   const MyCoursePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('My Course Page'),
//     );
//   }
// }

// class FavoritePage extends StatelessWidget {
//   const FavoritePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Favorite Page'),
//     );
//   }
// }

// class AccountPage extends StatelessWidget {
//   const AccountPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('Account Page'),
//     );
//   }
// }
