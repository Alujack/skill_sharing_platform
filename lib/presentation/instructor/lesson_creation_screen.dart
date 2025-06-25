import 'package:flutter/material.dart';
import 'package:skill_sharing_platform/services/lesson_service.dart';
import 'package:skill_sharing_platform/widgets/video_picker.dart';

class LessonCreationScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;

  const LessonCreationScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LessonCreationScreenState createState() => _LessonCreationScreenState();
}

class _LessonCreationScreenState extends State<LessonCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _videoUrl = '';
  bool _isLoading = false;

  Future<void> _createLesson() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      await LessonService.createLesson({
        "title": _title,
        "videoUrl": _videoUrl,
        "courseId": widget.courseId,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lesson added successfully!')),
      );
      _formKey.currentState!.reset();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Lessons to ${widget.courseTitle}'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Course: ${widget.courseTitle}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Lesson Title*'),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                        onSaved: (v) => _title = v!,
                      ),
                      SizedBox(height: 16),
                      VideoPickerWidget(
                        onVideoSelected: (String url) {
                          _videoUrl = url;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _createLesson,
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                              ),
                              child: Text('Add Lesson'),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                              ),
                              child: Text('Done'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
