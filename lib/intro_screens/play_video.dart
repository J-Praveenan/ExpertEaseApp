import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class PlayVideo extends StatefulWidget {
  const PlayVideo({Key? key, required this.videoURL, required this.videoName, required this.tutorName})
      : super(key: key);

  final String videoURL;
  final String videoName;
  final String tutorName;

  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  late FlickManager flickManager;

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.videoURL),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Video'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlickVideoPlayer(
              flickManager: flickManager,
              flickVideoWithControls: const FlickVideoWithControls(
                controls: FlickPortraitControls(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(widget.videoName),
            const SizedBox(
              height: 10,
            ),
            Text('Tutor Name : '+widget.tutorName),
          ],
        ),
      ),
    );
  }
}