import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_sharing_platform/auth_provider.dart';
import 'package:skill_sharing_platform/services/favourite_service.dart';
import 'package:skill_sharing_platform/widgets/product_card.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<dynamic> _courses = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchStudentCourses();
  }

  Future<void> _fetchStudentCourses() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id;

      if (userId == null) {
        return;
      }

      final courses = await FavouriteService.getFavouriteCourse(userId);
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load courses: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _courses.isEmpty
            ? const Center(child: Text("No favorite courses found."))
            : ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: _courses[index]['course']);
                },
              ),
      ),
    );
  }
}
