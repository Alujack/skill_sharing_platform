// lib/widgets/video_player.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.autoPlay = false,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer(widget.videoUrl);
  }

  // This is crucial for handling video URL changes
  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoUrl != oldWidget.videoUrl) {
      _controller.dispose(); // Dispose old controller
      _initializeVideoPlayer(widget.videoUrl); // Initialize new one
    }
  }

  void _initializeVideoPlayer(String videoUrl) {
    // Check if the videoUrl is a network URL or an asset
    if (videoUrl.startsWith('http://') || videoUrl.startsWith('https://')) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
              if (widget.autoPlay) {
                _controller.play();
                _isPlaying = true;
              }
            });
          }
        }).catchError((error) {
          debugPrint("Error initializing network video: $error");
          if(mounted) {
            setState(() {
              _isInitialized = false; // Indicate initialization failed
            });
          }
        });
    } else {
      // Assuming it's an asset path
      _controller = VideoPlayerController.asset(videoUrl)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
              if (widget.autoPlay) {
                _controller.play();
                _isPlaying = true;
              }
            });
          }
        }).catchError((error) {
          debugPrint("Error initializing asset video: $error");
          if(mounted) {
            setState(() {
              _isInitialized = false; // Indicate initialization failed
            });
          }
        });
    }

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        width: double.infinity,
        height: 220,
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying ? _controller.pause() : _controller.play();
        });
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          VideoProgressIndicator(_controller, allowScrubbing: true),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 50),
              child: _isPlaying
                  ? const SizedBox.shrink()
                  : Container(
                      color: Colors.black26,
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 100.0,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}