import 'package:flutter/material.dart'; // Not directly used here, but good to keep if you had other video player logic
import '../services/course_service.dart';
// import '../widgets/video_player_beta.dart';
import 'package:skill_sharing_platform/widgets/video_player.dart';
import 'package:skill_sharing_platform/constants/app_constant.dart';

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
  String currentVideoUrl = '';
  int currentLessonIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchCourseDetails();
  }

  String _getFullVideoUrl(String relativeUrl) {
    // Check if the URL is already a full URL (e.g., from an external service)
    if (relativeUrl.startsWith('http://') ||
        relativeUrl.startsWith('https://')) {
      return relativeUrl;
    }
    // Otherwise, prepend the base URL
    return '${AppConstants.baseUrl}$relativeUrl';
  }

  Future<void> _fetchCourseDetails() async {
    print("course id ==${widget.courseId}");
    try {
      final data = await CoursesService.getCourseById(widget.courseId);
      if (mounted) {
        setState(() {
          courseData = data;
          isLoading = false;
          // Set the first lesson video URL if available
          if (data['lessons'] != null && data['lessons'].isNotEmpty) {
            // Ensure lessons are sorted by ID or a 'sequence' field if they appear out of order
            // based on your JSON example, the lessons are not sorted by title or ID initially.
            // If order matters for "Lesson 1, Lesson 2...", you might want to sort them.
            // For now, we'll just pick the first one from the fetched list.
            currentLessonIndex = 0;
            currentVideoUrl = _getFullVideoUrl(
                data['lessons'][currentLessonIndex]['videoUrl'] ?? '');
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load course details: $e';
        });
      }
      debugPrint('Error loading course details: $e');
    }
  }

  void _playLesson(String videoUrl, int lessonIndex) {
    // Only update if the new video URL is different to avoid unnecessary re-renders
    if (videoUrl != currentVideoUrl) {
      setState(() {
        currentVideoUrl = videoUrl;
        currentLessonIndex = lessonIndex;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Section
            if (currentVideoUrl.isNotEmpty)
              VideoPlayerWidget(
                videoUrl: currentVideoUrl,
                autoPlay:
                    false, // You can set this to true if you want immediate playback
              )
            else
              Container(
                width: double.infinity,
                height: 220,
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'No video available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

            // Course Info Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseData!['title'] ?? 'No title available',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        courseData!['instructor']?['name'] ??
                            'Unknown Instructor',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.category, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        courseData!['category']?['name'] ?? 'Unknown Category',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Course Description
                  Text(
                    courseData!['description'] ?? 'No description available',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Course Content
                  const Text(
                    'Course Content',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Course Sections and Lessons
                  if (courseData!['lessons'] != null &&
                      courseData!['lessons'].isNotEmpty)
                    // You were calling _buildLessonsOnly here, which is correct since your data only has a flat list of lessons.
                    // If you had 'sections' within your courseData, you would use _buildCourseContent.
                    _buildLessonsOnly(courseData!['lessons'])
                  else
                    const Text('No content available for this course'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Your _buildCourseContent is for a nested structure of sections -> lessons.
  // Given your JSON, you have a flat list of lessons directly under courseData.
  // So, _buildLessonsOnly is the correct one to use.
  Widget _buildLessonsOnly(List<dynamic> lessons) {
    // It's good practice to sort lessons if their order in the JSON isn't guaranteed
    // to be the desired playback order (e.g., by title, or a specific 'order' field if available).
    // For your given data, they are not sorted by ID or title initially.
    // Example sort by title (e.g., "1. lesson 1", "2. lesson 2"):
    lessons
        .sort((a, b) => (a['title'] as String).compareTo(b['title'] as String));

    return Column(
      children: lessons.asMap().entries.map<Widget>((entry) {
        int lessonIndex = entry.key; // This is the index in the *sorted* list
        var lesson = entry.value;
        bool isCurrentLesson = currentLessonIndex == lessonIndex;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: isCurrentLesson ? Colors.blue[50] : Colors.white,
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCurrentLesson ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isCurrentLesson &&
                        currentVideoUrl ==
                            _getFullVideoUrl(lesson['videoUrl'] ??
                                '') // Check if *this* video is currently playing
                    ? Icons.pause
                    : Icons.play_arrow,
                color: isCurrentLesson ? Colors.white : Colors.grey[600],
              ),
            ),
            title: Text(
              lesson['title'] ?? 'Untitled Lesson',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isCurrentLesson ? Colors.blue : Colors.black,
              ),
            ),
            subtitle: Text(
              'Video • ${lesson['duration'] ?? '10:00'}', // Assuming 'duration' exists or provide a default
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              // *** Corrected: Use 'videoUrl' from your JSON and make sure it's a full URL ***
              _playLesson(
                _getFullVideoUrl(lesson['videoUrl'] ?? ''),
                lessonIndex,
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
