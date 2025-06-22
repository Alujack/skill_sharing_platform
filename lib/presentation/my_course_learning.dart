import 'package:flutter/material.dart';
import '../services/course_service.dart';
import '../widgets/video_player.dart';

class MyCourseLearning extends StatefulWidget {
  final int courseId;

  const MyCourseLearning({super.key, required this.courseId});

  @override
  State<MyCourseLearning> createState() => _MyCourseLearningState();
}

class _MyCourseLearningState extends State<MyCourseLearning> {
  Map<String, dynamic>? courseData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCourseDetails();
  }

  Future<void> _fetchCourseDetails() async {
    try {
      final data = await CoursesService.getCourseById(widget.courseId);
      if (mounted) {
        setState(() {
          courseData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load course details';
        });
      }
      debugPrint('Error loading course details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(errorMessage)),
      );
    }

    if (courseData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(child: Text('Course not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const SizedBox(height: 10),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Static video player (as in your original implementation)
              VideoPlayerWidget(videoUrl: 'assets/videos/NextJsOverview.mp4'),

              const SizedBox(height: 10),
              Text(
                courseData!['title'] ?? 'No title available',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              // Course content sections and lessons
              if (courseData!['sections'] != null &&
                  courseData!['sections'].isNotEmpty)
                _buildCourseContent(courseData!['sections'])
              else
                const Text('No content available for this course'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseContent(List<dynamic> sections) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        for (var section in sections) ...[
          Text(
            'Section ${sections.indexOf(section) + 1} - ${section['title'] ?? 'Untitled section'}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          if (section['lessons'] != null && section['lessons'].isNotEmpty)
            Column(
              children: section['lessons'].map<Widget>((lesson) {
                return ListTile(
                  leading: const Icon(Icons.play_circle_outline),
                  title: Text(lesson['title'] ?? 'Untitled lesson'),
                  subtitle: const Text('Video - 10:00'),
                  onTap: () {
                    // Handle lesson selection if needed
                  },
                );
              }).toList(),
            )
          else
            const Text('No lessons in this section'),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
