import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  const Video({super.key});

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/video.mp4")
      ..initialize().then((_) {
        setState(() {}); // Update the UI after initialization
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Player')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rotate the video 90 degrees
              Transform.rotate(
                angle:
                    -1.5708, // Rotate 90 degrees counter-clockwise (in radians)
                child: Transform.scale(
                  scale: 1.7,
                  child: AspectRatio(
                    aspectRatio: 4 / 7, // Adjust the aspect ratio as needed
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
              SizedBox(height: 20),
              VideoProgressIndicator(_controller, allowScrubbing: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
