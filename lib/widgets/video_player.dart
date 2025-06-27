import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:skill_sharing_platform/constants/app_constant.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final url = widget.videoUrl;
    print("this is video == ${AppConstants.baseUrl}$url");

    try {
      _controller = url.startsWith('http')
          ? VideoPlayerController.network(url)
          : VideoPlayerController.network("${AppConstants.baseUrl}$url");

      await _controller.initialize();
      _controller.setLooping(true);
      if (widget.autoPlay) {
        _controller.play();
      }
      setState(() => _initialized = true);
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFullScreen() {
    if (_isFullScreen) {
      Navigator.of(context).pop();
      setState(() => _isFullScreen = false);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FullScreenVideoPlayer(
            controller: _controller,
            onExitFullScreen: () => (() => _isFullScreen = false),
          ),
          fullscreenDialog: true,
        ),
      ).then((_) => setState(() => _isFullScreen = false));
      setState(() => _isFullScreen = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onDoubleTap: _toggleFullScreen,
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            VideoPlayer(_controller),
            VideoControlsOverlay(
              controller: _controller,
              onFullScreenTap: _toggleFullScreen,
              isFullScreen: _isFullScreen,
            ),
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.red,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.white24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoControlsOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onFullScreenTap;
  final bool isFullScreen;

  const VideoControlsOverlay({
    super.key,
    required this.controller,
    required this.onFullScreenTap,
    required this.isFullScreen,
  });

  @override
  State<VideoControlsOverlay> createState() => _VideoControlsOverlayState();
}

class _VideoControlsOverlayState extends State<VideoControlsOverlay> {
  bool _showControls = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  double _volume = 1.0;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.controller.value.isPlaying;
    _isMuted = widget.controller.value.volume == 0;
    _volume = widget.controller.value.volume;
    _position = widget.controller.value.position;
    _duration = widget.controller.value.duration;

    widget.controller.addListener(_updateState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      setState(() {
        _isPlaying = widget.controller.value.isPlaying;
        _isMuted = widget.controller.value.volume == 0;
        _volume = widget.controller.value.volume;
        _position = widget.controller.value.position;
        _duration = widget.controller.value.duration;
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (widget.controller.value.isPlaying) {
        widget.controller.pause();
      } else {
        widget.controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleMute() {
    setState(() {
      if (widget.controller.value.volume == 0) {
        widget.controller.setVolume(_volume > 0 ? _volume : 1.0);
        _isMuted = false;
      } else {
        _volume = widget.controller.value.volume;
        widget.controller.setVolume(0);
        _isMuted = true;
      }
    });
  }

  void _seekForward() {
    final newPosition =
        widget.controller.value.position + const Duration(seconds: 10);
    widget.controller.seekTo(newPosition < _duration ? newPosition : _duration);
  }

  void _seekBackward() {
    final newPosition =
        widget.controller.value.position - const Duration(seconds: 10);
    widget.controller
        .seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControls,
      child: AnimatedOpacity(
        opacity:
            _showControls || !widget.controller.value.isPlaying ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: Stack(
            children: [
              if (widget.isFullScreen)
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: widget.onFullScreenTap,
                  ),
                ),
              Positioned(
                top: widget.isFullScreen ? 40 : 10,
                right: 10,
                child: IconButton(
                  icon: Icon(
                    widget.isFullScreen
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                    color: Colors.white,
                  ),
                  onPressed: widget.onFullScreenTap,
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10,
                          color: Colors.white, size: 30),
                      onPressed: _seekBackward,
                    ),
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10,
                          color: Colors.white, size: 30),
                      onPressed: _seekForward,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 50,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                  ),
                  onPressed: _toggleMute,
                ),
              ),
              Positioned(
                bottom: 50,
                right: 10,
                child: Text(
                  '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onExitFullScreen;

  const FullScreenVideoPlayer({
    super.key,
    required this.controller,
    required this.onExitFullScreen,
  });

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideControlsTimer();
    }
  }

  void _exitFullScreen() {
    // Make sure to call the callback and pop the navigator
    widget.onExitFullScreen();
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          if (didPop) {
            widget.onExitFullScreen();
          }
        },
        child: GestureDetector(
          onTap: _toggleControls,
          child: OrientationBuilder(
            builder: (context, orientation) {
              return Stack(
                children: [
                  // Video player
                  Center(
                    child: AspectRatio(
                      aspectRatio: widget.controller.value.aspectRatio,
                      child: VideoPlayer(widget.controller),
                    ),
                  ),

                  // Video controls overlay
                  if (_showControls)
                    VideoControlsOverlay(
                      controller: widget.controller,
                      onFullScreenTap: _exitFullScreen,
                      isFullScreen: true,
                    ),

                  // Close button for landscape mode
                  if (orientation == Orientation.landscape && _showControls)
                    Positioned(
                      right: 20,
                      top: 20,
                      child: SafeArea(
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: _exitFullScreen,
                          splashRadius: 25,
                          tooltip: 'Exit fullscreen',
                        ),
                      ),
                    ),

                  // Back button for portrait mode
                  if (orientation == Orientation.portrait && _showControls)
                    Positioned(
                      left: 20,
                      top: 20,
                      child: SafeArea(
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: _exitFullScreen,
                          splashRadius: 25,
                          tooltip: 'Back',
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
