import 'dart:async';
import 'package:skill_sharing_platform/api_service.dart';
import 'package:skill_sharing_platform/constants/app_constant.dart';

class CategoriesService {
  final ApiService _apiService;

  // Constructor that accepts an ApiService instance
  CategoriesService(this._apiService);

  // Alternatively, you can create a default constructor
  CategoriesService.defaultConstructor() : _apiService = ApiService();

  Future<List<dynamic>> getAllCategories() async {
    try {
      final response = await _apiService.get(AppConstants.categories);

      if (response['success'] == true && response['data'] != null) {
        return response['data'] as List<dynamic>;
      } else {
        throw ApiException('Invalid response format', 0);
      }
    } on ApiException catch (e) {
      throw ApiException(
          'Failed to load categories: ${e.message}', e.statusCode);
    } catch (e) {
      throw ApiException('Unexpected error: ${e.toString()}', 0);
    }
  }

  Future<dynamic> getCategoryById(String id) async {
    try {
      final response = await _apiService.get(AppConstants.categoryById(id));

      if (response['success'] == true && response['data'] != null) {
        return response['data'];
      } else {
        throw ApiException('Invalid response format', 0);
      }
    } on ApiException catch (e) {
      throw ApiException('Failed to load category: ${e.message}', e.statusCode);
    } catch (e) {
      throw ApiException('Unexpected error: ${e.toString()}', 0);
    }
  }

  Future<dynamic> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final response = await _apiService.post(
        AppConstants.categories,
        body: categoryData,
      );

      if (response['success'] == true) {
        return response['data'];
      } else {
        throw ApiException(
            response['message'] ?? 'Failed to create category', 0);
      }
    } on ApiException catch (e) {
      throw ApiException(
          'Failed to create category: ${e.message}', e.statusCode);
    }
  }

  Future<dynamic> updateCategory(
      String id, Map<String, dynamic> updateData) async {
    try {
      final response = await _apiService.put(
        AppConstants.categoryById(id),
        body: updateData,
      );

      if (response['success'] == true) {
        return response['data'];
      } else {
        throw ApiException(
            response['message'] ?? 'Failed to update category', 0);
      }
    } on ApiException catch (e) {
      throw ApiException(
          'Failed to update category: ${e.message}', e.statusCode);
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      final response = await _apiService.delete(AppConstants.categoryById(id));

      if (response['success'] == true) {
        return true;
      } else {
        throw ApiException(
            response['message'] ?? 'Failed to delete category', 0);
      }
    } on ApiException catch (e) {
      throw ApiException(
          'Failed to delete category: ${e.message}', e.statusCode);
    }
  }
}
