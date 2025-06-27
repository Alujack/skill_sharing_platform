import 'package:flutter/material.dart';
import 'package:skill_sharing_platform/widgets/video_player.dart';

class LessonDetailScreen extends StatelessWidget {
  final Map<String, dynamic> lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final title = lesson['title'] ?? 'Lesson Detail';
    final videoUrl = lesson['videoUrl'];
    print("video == ${videoUrl}");

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: $title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            if (videoUrl != null && videoUrl.toString().isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Video Preview:',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 12),
                  VideoPlayerWidget(videoUrl: videoUrl),
                ],
              )
            else
              const Text('No video preview available'),
          ],
        ),
      ),
    );
  }
}
