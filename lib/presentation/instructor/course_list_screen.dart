import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_sharing_platform/auth_provider.dart';
import 'package:skill_sharing_platform/presentation/instructor/course_creation_screen.dart';
import 'package:skill_sharing_platform/presentation/instructor/course_update_screen.dart'; // Add this import
import 'package:skill_sharing_platform/presentation/instructor/lesson_creation_screen.dart';
import 'package:skill_sharing_platform/presentation/instructor/lesson_list_screen.dart';
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

  void _navigateToEditCourse(dynamic course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseUpdateScreen(course: course),
      ),
    ).then((result) {
      // If result is true, reload the courses
      if (result == true) {
        _loadCourses();
      }
    });
  }

  Future<void> _deleteCourse(dynamic course) async {
    final shouldDelete = await _showDeleteConfirmDialog(course);

    if (shouldDelete == true) {
      try {
        await CoursesService.deleteCourse(course['id']);

        // Remove the course from the list immediately for better UX
        setState(() {
          _courses.removeWhere((c) => c['id'] == course['id']);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Course "${course['title']}" deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting course: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );

        // Reload courses to ensure consistency
        _loadCourses();
      }
    }
  }

  Future<bool?> _showDeleteConfirmDialog(dynamic course) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to delete this course?'),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'] ?? 'Untitled Course',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\$${(course['price'] ?? 0).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'This action cannot be undone. All lessons associated with this course will also be deleted.',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
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
              child: _courses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No courses yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap the + button to create your first course',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _courses.length,
                      itemBuilder: (context, index) {
                        final course = _courses[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: InkWell(
                            onTap: () => _navigateToLessonList(course),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          course['title'] ?? 'No Title',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        if (course['description'] != null &&
                                            course['description']
                                                .toString()
                                                .isNotEmpty)
                                          Text(
                                            course['description'],
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        SizedBox(height: 4),
                                        Text(
                                          '\$${(course['price'] ?? 0).toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () =>
                                            _navigateToAddLesson(course),
                                        tooltip: 'Add Lesson',
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.deepPurple,
                                        ),
                                        onPressed: () =>
                                            _navigateToEditCourse(course),
                                        tooltip: 'Edit Course',
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => _deleteCourse(course),
                                        tooltip: 'Delete Course',
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
