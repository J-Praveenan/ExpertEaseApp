// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expert_ease/services/auth/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'chat_page.dart';

// class TutorHome extends StatefulWidget {
//   const TutorHome({super.key});

//   @override
//   State<TutorHome> createState() => _TutorHomeState();
// }

// class _TutorHomeState extends State<TutorHome> {

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // sign user out
//   void signOut() {
//     // get auth service
//     final authService = Provider.of<AuthService>(context, listen: false);

//     authService.signOut();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Learner Home Page'),
//         actions: [
//           // sign out button
//           IconButton(
//             onPressed: signOut,
//             icon: const Icon(Icons.login),
//           )
//         ],
//       ),


    
//       body:_buildUserList(),

//     );
//   }

//   // build a list of users except for the current logged in user
//  Widget _buildUserList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('users').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Text('error');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Text('loading...');
//         }

//         return ListView(
//           children: snapshot.data!.docs
//               .map<Widget>((doc) => _builderUserListItem(doc))
//               .toList(),
//         );
//       },
//     );
//   } 

// Widget _builderUserListItem(DocumentSnapshot document) {
//   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

//   // Check for null emails and perform a case-insensitive comparison
//   //String currentUserEmail = _auth.currentUser?.email?.toLowerCase() ?? '';
//   //String firestoreUserEmail = (data['email'] as String?)?.toLowerCase() ?? '';

//   // Display all users except the current user
//   if (_auth.currentUser!.email != data['email']) {
//     return ListTile(
//       title: Text(data['email']),
//       onTap: () {
//         // Navigate to the chat page
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChatPage(
//               receiverUserEmail: data['email'],
//               receiverUserID: data['uid'],
//             ),
//           ),
//         );
//       },
//     );
//   } else {
//     // Return an empty container for the current user
//     return Container();
//   }
// }

// }


import 'dart:io';
import 'package:expert_ease/intro_screens/video_list.dart';
import 'package:flutter/material.dart';
import 'package:expert_ease/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:expert_ease/resources/save_video.dart';

class TutorHome extends StatefulWidget {
  const TutorHome({super.key});

  @override
  State<TutorHome> createState() => _VideoUploadingPageState();
}

class _VideoUploadingPageState extends State<TutorHome> {
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
        title: const Text('Tutor Home'),
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
