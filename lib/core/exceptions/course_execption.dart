// lib/core/exceptions/course_exceptions.dart
class CourseException implements Exception {
  final String message;
  final int? statusCode;

  CourseException(this.message, {this.statusCode});

  @override
  String toString() => 'CourseException: $message (Status Code: $statusCode)';
}

class CourseNotFoundException extends CourseException {
  CourseNotFoundException() : super('Course not found', statusCode: 404);
}

class CourseCreationException extends CourseException {
  CourseCreationException(String message) : super(message, statusCode: 400);
}