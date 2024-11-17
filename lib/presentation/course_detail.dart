import 'package:flutter/material.dart';

class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key});

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
              const SizedBox(height: 5),
              Text(
                'JavaScript is a multi-paradigm, dynamic language with types and operators, standard built-in objects, and methods.',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const Text(
                    '4.2 ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('(2k ratings) 236k Students',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('Created by ',
                      style: TextStyle(color: Colors.grey[700])),
                  const Text('Yoeurn Yan',
                      style: TextStyle(color: Colors.blue)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.update, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 4),
                  const Text('Last updated 12/2024'),
                  const SizedBox(width: 16),
                  Icon(Icons.language, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 4),
                  const Text('Khmer'),
                  const SizedBox(width: 16),
                  Icon(Icons.closed_caption, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 4),
                  const Text('English'),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                '\$99.99 ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Text(
                '\$199.99',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 14, 0, 212),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Center(
                  child: Text(
                    'Buy now',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Center(
                  child: Text(
                    'Add to favourite',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Curriculum',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'What you’ll learn',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children: List.generate(
                  8,
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
        const Text(
          '4 sections • 100 lectures • 10h 13m total length',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
