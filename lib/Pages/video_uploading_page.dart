import 'dart:io';
import 'package:flutter/material.dart';
import 'package:expert_ease/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:expert_ease/resources/save_video.dart';

class VideoUploadingPage extends StatefulWidget {
  const VideoUploadingPage({super.key});

  @override
  State<VideoUploadingPage> createState() => _VideoUploadingPageState();
}

class _VideoUploadingPageState extends State<VideoUploadingPage> {
  String? _videoURL;
  VideoPlayerController? _controller;
  String? _downloadURL;

  @override
  void dispose() { 
    _controller?.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Upload'),
      ),
      body: Center(
        child: _videoURL != null
            ? _videoPreviewWidget()
            : Text('No Video Selected'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickVideo,
        child: const Icon(
          (Icons.video_library),
        ),
      ),
    );
  }

  void _pickVideo() async {
    _videoURL = await pickVideo();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.file(File(_videoURL!))
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  }

  Widget _videoPreviewWidget() {
    if (_controller != null) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          ElevatedButton(onPressed: _uploadVideo, child: const Text('Upload')),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  void _uploadVideo() async {
    _downloadURL = await StoreVideo().uploadVideo(_videoURL!);
    await StoreVideo().saveVideoData(_downloadURL!);
    setState(() {
      _videoURL = null;
    });
  }
}
