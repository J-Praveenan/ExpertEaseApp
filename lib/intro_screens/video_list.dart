import 'package:expert_ease/intro_screens/play_video.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoList extends StatefulWidget {
  const VideoList({super.key});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video List'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('videos').snapshots(),
              builder: (context, snapshot) {
                List<Row> videoWidgets = [];
                if (!snapshot.hasData) {
                  const CircularProgressIndicator();
                } else {
                  final videos = snapshot.data?.docs.reversed.toList();
                  for (var video in videos!) {
                    final videoWidget = Row(
                      children: [
                        Text(video['name']),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return PlayVideo(
                                    videoURL: video['url'],
                                    videoName: video['name'],
                                  );
                                },
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_arrow_rounded),
                        ),
                      ],
                    );
                    videoWidgets.add(videoWidget);
                  }
                }
                return Expanded(
                  child: ListView(
                    children: videoWidgets,
                  ),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
