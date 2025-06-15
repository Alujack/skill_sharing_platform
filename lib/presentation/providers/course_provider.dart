// lib/features/course/presentation/providers/course_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_sharing_platform/data/models/course_model.dart';
import 'package:skill_sharing_platform/data/repositories/course_repository.dart';

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  final authToken = ref.watch(authTokenProvider); // You need to have this provider
  return CourseRepository(CourseService(authToken));
});

final coursesProvider = FutureProvider<List<Course>>((ref) async {
  return ref.read(courseRepositoryProvider).getAllCourses();
});

final instructorCoursesProvider = FutureProvider.family<List<Course>, int>((ref, instructorId) async {
  return ref.read(courseRepositoryProvider).getInstructorCourses(instructorId);
});

final courseProvider = FutureProvider.family<Course, int>((ref, id) async {
  return ref.read(courseRepositoryProvider).getCourseById(id);
});