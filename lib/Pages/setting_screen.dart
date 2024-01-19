import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_ease/Pages/login_page.dart';
import 'package:expert_ease/Pages/manage_tutor_profile.dart';
import 'package:expert_ease/Pages/messages_screen.dart';
import 'package:expert_ease/Pages/tut_home.dart';
import 'package:expert_ease/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  // sign user out

  // sign user out
  void signOut() {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();

    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage(
                onTap: () {},
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Settings",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30),
              ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("images/tutor1.jpeg"),
                ),
                title: Text(
                  "${user?.email ?? 'User'}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                  ),
                ),
                subtitle: Text("Profile"),
              ),
              Divider(height: 50),
              ListTile(
                onTap: () {
                  //manage account function call

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => tutScreen(),));
                  
                },
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.home,
                    color: Colors.blue,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Home",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              SizedBox(height: 20),
              ListTile(
                onTap: () {
                      //manage account function call

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateUserProfile(onTap: () {  },)),
                  );
                },
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                   CupertinoIcons.person,
                    color: Colors.deepPurple,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              SizedBox(height: 20),
              // ListTile(
              //   onTap: () {
                  
              //   },
              //   leading: Container(
              //     padding: EdgeInsets.all(10),
              //     decoration: BoxDecoration(
              //       color: Colors.indigo.shade100,
              //       shape: BoxShape.circle,
              //     ),
              //     child: Icon(
              //       Icons.privacy_tip_outlined,
              //       color: Colors.indigo,
              //       size: 35,
              //     ),
              //   ),
              //   title: Text(
              //     "Privacy",
              //     style: TextStyle(
              //       fontWeight: FontWeight.w500,
              //       fontSize: 20,
              //     ),
              //   ),
              //   trailing: Icon(Icons.arrow_forward_ios_rounded),
              // ),
              // SizedBox(height: 20),
              ListTile(
                onTap: () {
                  
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MessageScreen(),)
                  );
                },
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline_outlined,
                    color: Colors.green,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Messages",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              SizedBox(height: 20),
              ListTile(
                onTap: () {},
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: Colors.orange,
                    size: 35,
                  ),
                ),
                title: Text(
                  "About Us",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              Divider(height: 40),
              ListTile(
                onTap: () {
                  signOut();
                },
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Colors.redAccent,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Log Out",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
