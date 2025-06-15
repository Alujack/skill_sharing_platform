// lib/features/course/data/repositories/course_repository.dart
import 'package:skill_sharing_platform/data/models/course_model.dart';
import 'package:skill_sharing_platform/services/course_service.dart';

class CourseRepository {
  final CourseService _service;

  CourseRepository(this._service);

  Future<List<Course>> getAllCourses() => _service.getAllCourses();
  Future<List<Course>> getInstructorCourses(int instructorId) => 
      _service.getInstructorCourses(instructorId);
  Future<Course> getCourseById(int id) => _service.getCourseById(id);
  // Future<Course> createCourse(Course course) => _service.createCourse(course);
  // Future<Course> updateCourse(int id, Course course) => _service.updateCourse(id, course);
  // Future<void> deleteCourse(int id) => _service.deleteCourse(id);
}