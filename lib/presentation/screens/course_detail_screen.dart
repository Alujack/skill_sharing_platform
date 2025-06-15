// lib/features/course/presentation/screens/course_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_app/features/course/presentation/providers/course_provider.dart';

class CourseDetailScreen extends ConsumerWidget {
  final int courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseProvider(courseId));

    return Scaffold(
      appBar: AppBar(title: const Text('Course Details')),
      body: courseAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (course) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(course.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('\$${course.price.toStringAsFixed(2)}', 
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Text('Category: ${course.category.name}'),
              const SizedBox(height: 16),
              Text('Instructor: ${course.instructor.name}'),
              const SizedBox(height: 16),
              Text(course.description),
            ],
          ),
        ),
      ),
    );
  }
}