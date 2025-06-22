import 'package:flutter/material.dart';
import 'package:skill_sharing_platform/presentation/my_course_learning.dart';
import 'package:skill_sharing_platform/services/student_service.dart';
import 'package:provider/provider.dart';
import 'package:skill_sharing_platform/auth_provider.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  List<dynamic> _courses = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';
  String _activeFilter = 'All';

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
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please login to view your courses';
        });
        return;
      }
      print("user == ${userId}");

      final courses = await StudentService.getStudentEnrollments(userId);
      print("course == ${courses}");
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

  List<dynamic> get _filteredCourses {
    List<dynamic> filtered = _courses;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((course) =>
              course['course']['title']
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              course['course']['description']
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply category filter (placeholder - you can implement actual filters)
    if (_activeFilter == 'Favourite') {
      // Implement favourite filter logic
    } else if (_activeFilter == 'Downloads') {
      // Implement downloads filter logic
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.1),
        child: AppBar(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilterButton(
                  label: 'All',
                  isActive: _activeFilter == 'All',
                  onPressed: () {
                    setState(() {
                      _activeFilter = 'All';
                    });
                  },
                ),
                FilterButton(
                  label: 'Downloads',
                  isActive: _activeFilter == 'Downloads',
                  onPressed: () {
                    setState(() {
                      _activeFilter = 'Downloads';
                    });
                  },
                ),
                FilterButton(
                  label: 'Favourite',
                  isActive: _activeFilter == 'Favourite',
                  onPressed: () {
                    setState(() {
                      _activeFilter = 'Favourite';
                    });
                  },
                ),
              ],
            ),
          ),

          // Loading and error states
          if (_isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_errorMessage.isNotEmpty)
            Expanded(
              child: Center(child: Text(_errorMessage)),
            )
          else if (_filteredCourses.isEmpty)
            const Expanded(
              child: Center(child: Text('No courses found')),
            )
          else
            // Course List
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchStudentCourses,
                child: ListView.builder(
                  itemCount: _filteredCourses.length,
                  itemBuilder: (context, index) {
                    final course = _filteredCourses[index];
                    return CourseItem(
                      course: course,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyCourseLearning(
                              courseId: course['id'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const FilterButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label),
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        side: BorderSide(
          color: isActive ? Colors.blue : Colors.grey,
        ),
        backgroundColor: isActive ? Colors.blue.withOpacity(0.1) : null,
      ),
    );
  }
}

class CourseItem extends StatelessWidget {
  final Map<String, dynamic> course;
  final VoidCallback onTap;

  const CourseItem({
    super.key,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: Image.asset(
          'assets/images/course.png', // Placeholder image
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(
          course['course']['title'] ?? 'Untitled Course',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course['course']['instructor']?['name'] ?? 'Unknown Instructor'),
            const SizedBox(height: 4),
            const Text(
              'Start course',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
