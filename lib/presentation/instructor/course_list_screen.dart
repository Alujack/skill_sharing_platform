import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_sharing_platform/auth_provider.dart';
import 'package:skill_sharing_platform/presentation/instructor/course_creation_screen.dart';
import 'package:skill_sharing_platform/presentation/instructor/lesson_creation_screen.dart';
import 'package:skill_sharing_platform/presentation/instructor/lesson_list_screen.dart'; // Add this import
import 'package:skill_sharing_platform/services/course_service.dart';

class CourseListScreen extends StatefulWidget {
  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  List<dynamic> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id;

      if (userId != null) {
        final data = await CoursesService.getInstructorCourses(userId);
        setState(() => _courses = data);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading courses: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToLessonList(dynamic course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonListScreen(
          courseId: course['id'],
          courseTitle: course['title'] ?? 'Untitled Course',
        ),
      ),
    );
  }

  void _navigateToAddLesson(dynamic course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonCreationScreen(
          courseId: course['id'],
          courseTitle: course['title'] ?? 'Untitled Course',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Courses'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CourseCreationScreen()),
            ).then((_) => _loadCourses()),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCourses,
              child: ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: InkWell(
                      onTap: () => _navigateToLessonList(course),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course['title'] ?? 'No Title',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '\$${(course['price'] ?? 0).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: () => _navigateToAddLesson(course),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed:
                                      () {}, // Implement edit functionality
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
