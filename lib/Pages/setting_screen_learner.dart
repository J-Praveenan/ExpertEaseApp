import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_ease/Pages/learner_home.dart';
import 'package:expert_ease/Pages/login_page.dart';
import 'package:expert_ease/Pages/manage_learner_profile%20.dart';
import 'package:expert_ease/Pages/messages_screen_for_tutors.dart';
import 'package:expert_ease/Pages/messages_screen_for_learners.dart';
import 'package:expert_ease/Pages/tut_home.dart';
import 'package:expert_ease/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearnerSettingsScreen extends StatefulWidget {
  @override
  State<LearnerSettingsScreen> createState() => _LearnerSettingsScreenState();
}

class _LearnerSettingsScreenState extends State<LearnerSettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  String? userName;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    // Retrieve the user's name from the 'userNewProfile' collection
    _firestore
        .collection('userLearnerProfile')
        .doc(user?.uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        setState(() {
          userName = snapshot.data()?['name'];
          imageUrl = snapshot.data()?['profileImage'];
        });
      }
    });
  }

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
                  backgroundImage: imageUrl != null
                      ? NetworkImage(imageUrl!)
                      : AssetImage("images/default_avatar.png")
                          as ImageProvider<Object>?,
                ),
                title: Text(
                  "${userName ?? user?.email}",
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
                        builder: (context) => LearnerHomeScreen(),
                      ));
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
                        builder: (context) => UpdateLearnerProfile(
                              onTap: () {},
                            )),
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
                        builder: (context) => MessageScreenForLearners(),
                      ));
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
