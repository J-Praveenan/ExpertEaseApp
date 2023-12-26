import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:expert_ease/Pages/chat_page.dart';
import 'package:expert_ease/Pages/video_uploading_page.dart';
import 'package:expert_ease/intro_screens/video_list.dart';
import 'package:flutter/material.dart';

class LearnerHomePage extends StatefulWidget {
  const LearnerHomePage({super.key});

  @override
  State<LearnerHomePage> createState() => _LearnerHomePageState();
}

class _LearnerHomePageState extends State<LearnerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learner Home'),
        backgroundColor: Colors.blue.shade200,
      ),

      backgroundColor: Colors.blue,

      // Drawer
      drawer: Drawer(
          child: Container(
        color: Colors.blue.shade200,
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Icon(Icons.person, size: 80,),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                'Home',
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LearnerHomePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text(
                'Chat',
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VideoUploadingPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.video_collection),
              title: Text(
                'Videos',
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VideoList()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VideoList()));
              },
            ),
          ],
        ),
      )),
      // Bottom NavigationBar
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.blue,
          animationDuration: Duration(milliseconds: 300),
          items: [
            Icon(
              Icons.home,   
            ),
            Icon(
              Icons.chat,
            ),
            Icon(
              Icons.video_collection,
            ),
          ]),
    );
  }
}
