
import 'package:flutter/material.dart';
import 'package:mini_social_feed_starter/features/feed/domain/entities/post.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostMedia extends StatefulWidget {
  final String mediaUrl;
  final MediaType type;
  const PostMedia({super.key, required this.mediaUrl, required this.type});

  @override
  State<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == MediaType.video) {
      _initVideo();
    }
  }

  Future<void> _initVideo() async {
    setState(() {
      _initialized = false;
      _error = false;
    });
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.mediaUrl),
      );
      await _controller!.setLooping(true);
      await _controller!.setVolume(0.0); // start muted for autoplay policies
      await _controller!.initialize();
      if (!mounted) return;
      setState(() => _initialized = true);
    } catch (e) {
      debugPrint('Video init error: $e');
      if (!mounted) return;
      setState(() => _error = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleVisibility(double visibleFraction) {
    if (_controller == null || !_initialized) return;
    if (visibleFraction >= 0.6 && !_controller!.value.isPlaying) {
      _controller!.play();
    } else if (visibleFraction <= 0.2 && _controller!.value.isPlaying) {
      _controller!.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == MediaType.image) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          widget.mediaUrl,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Container(
            height: 200,
            color: Colors.black12,
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image),
          ),
        ),
      );
    }

    if (_error) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black12,
          alignment: Alignment.center,
          child: OutlinedButton.icon(
            onPressed: _initVideo,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry video'),
          ),
        ),
      );
    }

    if (!_initialized) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final aspect = _controller!.value.aspectRatio == 0
        ? 16 / 9
        : _controller!.value.aspectRatio;

    return VisibilityDetector(
      key: ValueKey(widget.mediaUrl),
      onVisibilityChanged: (info) => _handleVisibility(info.visibleFraction),
      child: AspectRatio(
        aspectRatio: aspect,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            VideoPlayer(_controller!),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                  setState(() {});
                },
                onDoubleTap: () async {
                  final vol = _controller!.value.volume;
                  await _controller!.setVolume(vol > 0 ? 0.0 : 1.0);
                  setState(() {});
                },
              ),
            ),
            VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
              padding: const EdgeInsets.only(bottom: 6, left: 8, right: 8),
            ),
          ],
        ),
      ),
    );
  }
}
