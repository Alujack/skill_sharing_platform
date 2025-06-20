import 'package:flutter/material.dart';
import 'package:skill_sharing_platform/widgets/video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:skill_sharing_platform/services/course_service.dart';

class CourseDetailPage extends StatefulWidget {
  final int courseId;

  const CourseDetailPage({super.key, required this.courseId});

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late VideoPlayerController _controller;
  Map<String, dynamic>? courseData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCourseDetails();
    // Initialize with empty video, will update when data loads
    _controller =
        VideoPlayerController.asset('assets/videos/NextJsOverview.mp4')
          ..initialize().then((_) {
            setState(() {}); 
          });
    _controller.setLooping(true); // Loop the video
  }

  Future<void> _fetchCourseDetails() async {
    try {
      final data = await CoursesService.getCourseById(widget.courseId);
      if (mounted) {
        setState(() {
          courseData = data;
          isLoading = false;
          // Update video controller with the first lesson video if available
          if (data['lessons'] != null && data['lessons'].isNotEmpty) {
            _controller =
                VideoPlayerController.asset('assets/videos/NextJsOverview.mp4')
                  ..initialize().then((_) {
                    if (mounted) setState(() {});
                  });
          }
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
  void dispose() {
    _controller.dispose();
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
      appBar: AppBar(
        title: Text(courseData!['title'] ?? 'Course Details'),
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
              // Show the first lesson video as the course preview
              if (courseData!['lessons'] != null &&
                  courseData!['lessons'].isNotEmpty)
                VideoPlayerWidget(
                    videoUrl: courseData!['lessons'][0]['videoUrl'])
              else
                const Placeholder(
                  fallbackHeight: 200,
                  child: Center(child: Text('No video available')),
                ),

              const SizedBox(height: 10),
              Text(
                courseData!['title'] ?? 'No title available',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                courseData!['description'] ?? 'No description available',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 10),

              // Static rating section since not in API
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Text(
                    '4.2 ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('(2k ratings) 236k Students',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 10),

              // Instructor info
              Row(
                children: [
                  const Text('Created by ',
                      style: TextStyle(color: Colors.grey)),
                  Text(
                    courseData!['instructor']?['name'] ?? 'Unknown instructor',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ],
              ),

              // Static metadata since not in API
              const Row(
                children: [
                  Icon(Icons.update, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('Last updated 12/2024'),
                  SizedBox(width: 16),
                  Icon(Icons.language, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('English'),
                ],
              ),
              const SizedBox(height: 20),

              // Price
              Text(
                '\$${courseData!['price']?.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              // Static original price for discount display
              const Text(
                '\$199.99',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(height: 10),

              // Action buttons
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 35, 0, 210),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Buy now',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Add to favourite',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),

              // Static "What you'll learn" section
              const Text(
                "What you'll learn",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        const Icon(Icons.check, color: Colors.black),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Lorem ipsum dolor sit amet consectetur. Nibh adipiscing orci nibh non.',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Lessons list
              const Text(
                'Curriculum',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '${courseData!['lessons']?.length ?? 0} lessons',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Lessons list
              if (courseData!['lessons'] != null &&
                  courseData!['lessons'].isNotEmpty)
                ...courseData!['lessons']
                    .map((lesson) => ListTile(
                          leading: const Icon(Icons.play_circle_outline),
                          title: Text(lesson['title'] ?? 'Untitled lesson'),
                          subtitle: const Text('Video - 10:00'),
                          onTap: () {},
                        ))
                    .toList()
              else
                const Text('No lessons available for this course'),
            ],
          ),
        ),
      ),
    );
  }
}
