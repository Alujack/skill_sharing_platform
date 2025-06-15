// lib/features/course/presentation/screens/course_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_app/features/course/data/models/course_model.dart';
import 'package:your_app/features/course/presentation/providers/course_provider.dart';
import 'package:your_app/features/course/presentation/screens/course_detail_screen.dart';

class CourseListScreen extends ConsumerWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: coursesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (courses) => ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return ListTile(
              title: Text(course.title),
              subtitle: Text('\$${course.price.toStringAsFixed(2)}'),
              trailing: Text(course.category.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailScreen(courseId: course.id),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}