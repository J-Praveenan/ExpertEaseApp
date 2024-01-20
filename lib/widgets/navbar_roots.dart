import 'package:expert_ease/Pages/learner_messages_screen.dart';
import 'package:expert_ease/Pages/learner_home.dart';
import 'package:expert_ease/Pages/messages_screen%20copy.dart';
import 'package:expert_ease/Pages/setting_screen_tutor.dart';
import 'package:expert_ease/Pages/video_upload.dart';
import 'package:expert_ease/intro_screens/view_video_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBarRoots extends StatefulWidget {
  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  final _screens = [
    //Home Screen
    LearnerHomeScreen(),

    //Messages Screen
    TutorMessageScreen(),

    //Schedule Screen
    VideoList(),

    //Settings Screen
    SettingsScreen(),
  ]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF7165D6),
          unselectedItemColor: Colors.black26,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items:[
            BottomNavigationBarItem(icon: Icon(Icons.home_filled),
            label: "Home",
            ),
             BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble_text_fill),
            label: "Chat",
            ),
             BottomNavigationBarItem(icon: Icon(Icons.calendar_month),
            label: "Schedule",
            ),
             BottomNavigationBarItem(icon: Icon(Icons.settings),
            label: "Setting",
            ),
          ]
        ),
      ),
    );
  }
}
