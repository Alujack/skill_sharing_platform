// lib/features/course/data/models/course_model.dart
class Course {
  final int id;
  final String title;
  final String description;
  final double price;
  final int instructorId;
  final int categoryId;
  final DateTime createdAt;
  final Category category;
  final Instructor instructor;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.instructorId,
    required this.categoryId,
    required this.createdAt,
    required this.category,
    required this.instructor,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      instructorId: json['instructorId'],
      categoryId: json['categoryId'],
      createdAt: DateTime.parse(json['createdAt']),
      category: Category.fromJson(json['category']),
      instructor: Instructor.fromJson(json['instructor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'category_id': categoryId,
    };
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Instructor {
  final int id;
  final int userId;
  final String name;
  final String bio;
  final String phone;
  final bool isApproved;
  final DateTime createdAt;

  Instructor({
    required this.id,
    required this.userId,
    required this.name,
    required this.bio,
    required this.phone,
    required this.isApproved,
    required this.createdAt,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      bio: json['bio'],
      phone: json['phone'],
      isApproved: json['isApproved'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}