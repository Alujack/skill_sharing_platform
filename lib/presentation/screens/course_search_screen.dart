import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_sharing_platform/core/utils/debouncer.dart';

class _CourseSearchScreenState extends ConsumerState<CourseSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  String _currentQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search courses...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            _debouncer.run(() {
              setState(() {
                _currentQuery = value;
              });
            });
          },
        ),
      ),
      // ... rest of the widget
    );
  }
}
