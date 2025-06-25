import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:video_compress/video_compress.dart';

class VideoPickerWidget extends StatefulWidget {
  final Function(String url) onVideoSelected;
  const VideoPickerWidget({super.key, required this.onVideoSelected});

  @override
  State<VideoPickerWidget> createState() => _VideoPickerWidgetState();
}

class _VideoPickerWidgetState extends State<VideoPickerWidget> {
  File? _videoFile;
  final ImagePicker _picker = ImagePicker();
  bool _isConverting = false;
  String _conversionStatus = '';
  double _compressionProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initVideoCompress();
  }

  void _initVideoCompress() {
    VideoCompress.setLogLevel(0);
  }

  Future<void> _pickVideo(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickVideo(source: source);
    if (pickedFile == null) return;

    setState(() {
      _isConverting = true;
      _conversionStatus = 'Processing video...';
      _compressionProgress = 0.0;
    });

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final originalFileName = p.basename(pickedFile.path);
      final fileNameWithoutExt = p.basenameWithoutExtension(originalFileName);

      // Create output path with .mp4 extension
      final outputPath = '${appDir.path}/${fileNameWithoutExt}_converted.mp4';

      // Check if the file is already mp4 with good compression
      if (p.extension(pickedFile.path).toLowerCase() == '.mp4') {
        final fileSize = await File(pickedFile.path).length();
        // If file is small enough (less than 50MB), just copy it
        if (fileSize < 50 * 1024 * 1024) {
          final savedVideo = await File(pickedFile.path).copy(outputPath);
          setState(() {
            _videoFile = savedVideo;
            _isConverting = false;
            _conversionStatus = 'Video ready!';
          });
          widget.onVideoSelected(savedVideo.path);
          return;
        }
      }

      setState(() {
        _conversionStatus = 'Compressing and converting to MP4...';
      });

      // Set up progress listener
      VideoCompress.compressProgress$.subscribe((progress) {
        setState(() {
          _compressionProgress = progress / 100.0;
        });
      });

      // Compress and convert video to mp4
      final MediaInfo? info = await VideoCompress.compressVideo(
        pickedFile.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (info != null && info.path != null) {
        // Copy the compressed video to our desired location
        final compressedFile = File(info.path!);
        final finalVideo = await compressedFile.copy(outputPath);

        // Clean up the temporary compressed file
        if (await compressedFile.exists()) {
          await compressedFile.delete();
        }

        setState(() {
          _videoFile = finalVideo;
          _isConverting = false;
          _conversionStatus = 'Compression successful!';
          _compressionProgress = 1.0;
        });
        widget.onVideoSelected(finalVideo.path);
      } else {
        throw Exception('Video compression failed');
      }
    } catch (e) {
      setState(() {
        _isConverting = false;
        _conversionStatus = 'Compression failed: ${e.toString()}';
        _compressionProgress = 0.0;
      });

      // Fallback: just copy the original file
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = p.basename(pickedFile.path);
        final savedVideo =
            await File(pickedFile.path).copy('${appDir.path}/$fileName');
        setState(() {
          _videoFile = savedVideo;
          _conversionStatus = 'Using original format';
        });
        widget.onVideoSelected(savedVideo.path);
      } catch (fallbackError) {
        setState(() {
          _conversionStatus = 'Error: ${fallbackError.toString()}';
        });
      }
    }
  }

  @override
  void dispose() {
    VideoCompress.cancelCompression();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_videoFile != null)
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Selected: ${p.basename(_videoFile!.path)}",
                    style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        if (_isConverting)
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: _compressionProgress,
                  backgroundColor: Colors.blue.shade100,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                SizedBox(height: 12),
                Text(
                  _conversionStatus,
                  style: TextStyle(
                      color: Colors.blue.shade700, fontWeight: FontWeight.w500),
                ),
                if (_compressionProgress > 0)
                  Text(
                    '${(_compressionProgress * 100).toInt()}%',
                    style: TextStyle(color: Colors.blue.shade600, fontSize: 12),
                  ),
              ],
            ),
          ),
        if (!_isConverting &&
            _conversionStatus.isNotEmpty &&
            _videoFile != null)
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: _conversionStatus.contains('failed') ||
                      _conversionStatus.contains('Error')
                  ? Colors.orange.shade50
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _conversionStatus.contains('failed') ||
                        _conversionStatus.contains('Error')
                    ? Colors.orange.shade200
                    : Colors.blue.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _conversionStatus.contains('failed') ||
                          _conversionStatus.contains('Error')
                      ? Icons.warning
                      : Icons.info,
                  color: _conversionStatus.contains('failed') ||
                          _conversionStatus.contains('Error')
                      ? Colors.orange.shade700
                      : Colors.blue.shade700,
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _conversionStatus,
                    style: TextStyle(
                      color: _conversionStatus.contains('failed') ||
                              _conversionStatus.contains('Error')
                          ? Colors.orange.shade700
                          : Colors.blue.shade700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isConverting
                    ? null
                    : () => _pickVideo(ImageSource.gallery),
                icon: Icon(Icons.video_library),
                label: Text('Pick from Gallery'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    _isConverting ? null : () => _pickVideo(ImageSource.camera),
                icon: Icon(Icons.videocam),
                label: Text('Record Video'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
