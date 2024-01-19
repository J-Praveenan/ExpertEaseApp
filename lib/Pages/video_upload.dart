import 'dart:io';
import 'package:expert_ease/components/my_button.dart';
import 'package:expert_ease/intro_screens/video_list.dart';
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
  String? _videoName; // New variable to store user's name
  String? _tutorName;

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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoList(),
                ),
              );
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: Center(
        child: _videoURL != null
            ? _videoPreviewWidget()
            : Text('No Video Selected'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _collectUserName(); // Collect user's name before picking video
          _pickVideo();
        },
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

  Future<void> _collectUserName() async {
    // Display a dialog to collect user's name
    TextEditingController videoNameController = TextEditingController();
    TextEditingController tutorNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter the video details.'),
        content: Column(
        mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: videoNameController,
              decoration: InputDecoration(labelText: 'Video Title'),
            ),
            TextField(
              controller: tutorNameController,
              decoration: InputDecoration(labelText: 'Tutor Name'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _videoName = videoNameController.text;
                _tutorName = tutorNameController.text;
              });
              Navigator.pop(context);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),

          const SizedBox(
            height: 10,
          ),
          MyButton(onTap: _uploadVideo, text: 'Upload')
          // ElevatedButton(onPressed: _uploadVideo, child: const Text('Upload')),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  void _uploadVideo() async {
    if (_videoName != null && _tutorName != null) {
      _downloadURL = await StoreVideo().uploadVideo(_videoURL!);
      await StoreVideo().saveVideoData(_downloadURL!, _videoName!, _tutorName!);
      setState(() {
        _videoURL = null;
        _tutorName = null;
      });
    } else {
      // Handle the case where user's name is not collected
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please enter your name before uploading the video.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}