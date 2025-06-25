import 'package:flutter/material.dart';
import 'package:skill_sharing_platform/presentation/instructor/lesson_creation_screen.dart';
import 'package:skill_sharing_platform/presentation/instructor/lesson_detail_screen.dart';
import 'package:skill_sharing_platform/services/lesson_service.dart';

class LessonListScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;

  const LessonListScreen({
    Key? key,
    required this.courseId,
    required this.courseTitle,
  }) : super(key: key);

  @override
  _LessonListScreenState createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  List<dynamic> _lessons = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final lessons =
          await LessonService.getLessonsByCourse(widget.courseId.toString());
      setState(() {
        _lessons = lessons;
      });
    } catch (e) {
      setState(() => _hasError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load lessons: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteLesson(String lessonId) async {
    try {
      await LessonService.deleteLesson(lessonId);
      _loadLessons(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lesson deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete lesson: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddLesson(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLessons,
          ),
        ],
      ),
      body: _buildLessonList(),
    );
  }

  Widget _buildLessonList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load lessons'),
            ElevatedButton(
              onPressed: _loadLessons,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_lessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No lessons available'),
            ElevatedButton(
              onPressed: _navigateToAddLesson,
              child: const Text('Add First Lesson'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _lessons.length,
      itemBuilder: (context, index) {
        final lesson = _lessons[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.video_library),
            title: Text(lesson['title'] ?? 'Untitled Lesson'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(lesson['id']),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonDetailScreen(lesson: lesson),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showDeleteDialog(int lessonId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lesson'),
        content: const Text('Are you sure you want to delete this lesson?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteLesson(lessonId.toString());
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddLesson() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonCreationScreen(
          courseId: widget.courseId,
          courseTitle: widget.courseTitle,
        ),
      ),
    );
    _loadLessons(); // Refresh after returning
  }
}
