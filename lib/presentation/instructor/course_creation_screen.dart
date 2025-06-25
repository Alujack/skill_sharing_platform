import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_sharing_platform/services/course_service.dart';
import 'package:skill_sharing_platform/services/categories_service.dart';
import 'package:skill_sharing_platform/auth_provider.dart';

class CourseCreationScreen extends StatefulWidget {
  const CourseCreationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CourseCreationScreenState createState() => _CourseCreationScreenState();
}

class _CourseCreationScreenState extends State<CourseCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController(text: '99.99');

  int? _selectedCategoryId;
  List<dynamic> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    try {
      final data = await CategoriesService.getAllCategories();
      setState(() {
        _categories = data;
        // If you need to convert string IDs to int:
        _categories = data
            .map((category) => {
                  ...category,
                  'id': int.tryParse(category['id'].toString()) ?? 0
                })
            .toList();
      });
    } catch (e) {
      _showError('Error loading categories: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createCourse() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null) {
      _showError('Please select a category');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final instructorId = authProvider.user?.id;

      if (instructorId == null) {
        throw Exception('User not authenticated');
      }

      await CoursesService.createCourse({
        "title": _titleController.text,
        "description": _descriptionController.text,
        "price": double.parse(_priceController.text),
        "instructorId": instructorId,
        "categoryId": _selectedCategoryId,
      });

      _showSuccess('Course created successfully!');
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showError('Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Course'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTitleField(),
                    const SizedBox(height: 20),
                    _buildDescriptionField(),
                    const SizedBox(height: 20),
                    _buildPriceField(),
                    const SizedBox(height: 30),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 30),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Course Title*',
        border: OutlineInputBorder(),
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description*',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      decoration: const InputDecoration(
        labelText: 'Price*',
        prefixText: '\$',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Required';
        if (double.tryParse(value!) == null) return 'Invalid price';
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildCategoryDropdown() {
    // Debug print to verify categories data
    debugPrint('Categories List: $_categories');
    debugPrint('Selected Category ID: $_selectedCategoryId');

    // If categories are empty, show a disabled dropdown
    if (_categories.isEmpty) {
      return DropdownButtonFormField<int>(
        decoration: const InputDecoration(
          labelText: 'Category*',
          border: OutlineInputBorder(),
          hintText: 'Loading categories...',
        ),
        items: const [],
        onChanged: null,
        validator: (value) => 'Categories not loaded yet',
      );
    }

    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Category*',
        border: OutlineInputBorder(),
        hintText: 'Select a category',
      ),
      value: _selectedCategoryId,
      items: _categories.map((category) {
        // Convert ID to int if needed
        final id = category['id'] is String
            ? int.tryParse(category['id'])
            : category['id'] as int?;

        return DropdownMenuItem<int>(
          value: id,
          child: Text(category['name']?.toString() ?? 'Unknown Category'),
        );
      }).toList(),
      onChanged: (int? newValue) {
        debugPrint('New selected value: $newValue');
        setState(() {
          _selectedCategoryId = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a category' : null,
      isExpanded: true,
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _createCourse,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Create Course',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
