import 'package:flutter/material.dart';
import 'package:skill_sharing_platform/services/lesson_service.dart';
import 'package:skill_sharing_platform/widgets/video_picker.dart';

class UpdateLessonScreen extends StatefulWidget {
  final Map<String, dynamic> lesson;
  final int courseId;
  final String courseTitle;

  const UpdateLessonScreen({
    super.key,
    required this.lesson,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  _UpdateLessonScreenState createState() => _UpdateLessonScreenState();
}

class _UpdateLessonScreenState extends State<UpdateLessonScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _videoUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _title = widget.lesson['title'] ?? '';
    _videoUrl = widget.lesson['video_url'] ?? '';
  }

  Future<void> _updateLesson() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_videoUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a video')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await LessonService.updateLesson(
        lessonId: widget.lesson['id'],
        title: _title,
        videoFilePath: _videoUrl,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lesson updated successfully!')),
      );
      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
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
        title: Text('Update Lesson - ${widget.courseTitle}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: _title,
                        decoration:
                            const InputDecoration(labelText: 'Lesson Title*'),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                        onSaved: (v) => _title = v!,
                      ),
                      const SizedBox(height: 16),
                      VideoPickerWidget(
                        initialVideoUrl: _videoUrl,
                        onVideoSelected: (String url) {
                          _videoUrl = url;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _updateLesson,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text('Update Lesson'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text('Cancel'),
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
