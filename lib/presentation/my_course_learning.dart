import 'package:flutter/material.dart';

class MyCourseLearning extends StatelessWidget {
  const MyCourseLearning({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
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
              Image.asset('assets/images/course_banner.png'),
              const SizedBox(height: 10),
              const Text(
                'Modern JavaScript From The Beginning to advance 2.0 (2024)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              CourseContent(),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseContent extends StatelessWidget {
  final List<String> sections = [
    'Javascript introduction',
    'React Basics',
    'Next.js Advanced',
    'Project and Conclusion'
  ];

  final List<String> videos =
      List.generate(10, (index) => '${index + 1}. Introduction to Next.js 14');

  CourseContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        for (var section in sections) ...[
          Text(
            'Section ${sections.indexOf(section) + 1} - $section',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Column(
            children: videos.map((video) {
              return ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: Text(video),
                subtitle: const Text('Video - 10:00'),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
