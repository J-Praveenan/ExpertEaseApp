import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_ease/Pages/messages_screen_for_tutors.dart';
import 'package:expert_ease/Pages/messages_screen_for_learners.dart';
import 'package:expert_ease/Pages/setting_screen_tutor.dart';
import 'package:expert_ease/Pages/setting_screen_learner.dart';
import 'package:expert_ease/Pages/tutor_details_display_for_learner.dart';
import 'package:expert_ease/intro_screens/view_video_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LearnerHomeScreen extends StatefulWidget {
   

  @override
  State<LearnerHomeScreen> createState() => _LearnerHomeScreenState();
}

class _LearnerHomeScreenState extends State<LearnerHomeScreen> {
  int _selectedIndex = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  List<Map<String, dynamic>> tutors = [];
  String? userName;
   String? imageTutorUrl;
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
           loadTutors();
        });
      }
    });
  }



Future<void> loadTutors() async {
  final QuerySnapshot tutorSnapshot = await _firestore
      .collection('users')
      .where('role', isEqualTo: 'Tutor')
      .get();

  for (final doc in tutorSnapshot.docs) {
    final Map<String, dynamic>? docData = doc.data() as Map<String, dynamic>?;
   

    if (docData != null) {
      final tutorUID = docData['uid'];

      if (tutorUID != null) {
        final tutorSubjectSnapshot =
            await _firestore.collection('userNewProfile').doc(tutorUID).get();

        final Map<String, dynamic>? tutorSubjectData =
            tutorSubjectSnapshot.data() as Map<String, dynamic>?;

      if (tutorSubjectData != null) {
          final tutorName = tutorSubjectData['name'];
          final tutorSubject = tutorSubjectData['subject'];
          final tutorBio = tutorSubjectData['bio'];
          final tutorLocation = tutorSubjectData['address'];
          //final tutorImage = tutorSubjectData['profileImage'];
          imageTutorUrl = tutorSubjectSnapshot.data()?['profileImage'];

          // Do something with tutorEmail and tutorSubject
          print('Tutor Name: $tutorName, Tutor Subject: $tutorSubject');

          setState(() {
            tutors.add({
              'name': tutorName,
              'subject': tutorSubject,
              'bio':tutorBio,
              'address':tutorLocation,
              'uid':tutorUID,
              'profileImage':imageTutorUrl,
            });
          });
        }
      }
    }
  }
}


  List<String> symptoms = [
    "ICT",
    "Maths",
    "English",
    "Science",
    "Web Development",
  ];

  List<String> imgs = [
    "tutor1.jpeg",
    "tutor2.jpeg",
    "tutor3.jpeg",
    "tutor4.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    final _screens = [
      SingleChildScrollView(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello ${userName ?? user?.email}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                  radius: 30,
                  backgroundImage: imageUrl != null
                      ? NetworkImage(imageUrl!)
                      : AssetImage("images/default_avatar.png") as ImageProvider<Object>?,
                ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xFFF0EEFA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Search for subject",
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "What are your preferred subjects?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(
              height: 70,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: symptoms.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Color(0xFFF4F6FA),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                      
                    ),
                    child: Center(
                      child: Text(
                        symptoms[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Popular Tutors",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
            GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: tutors.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Map<String, dynamic> tutorData = tutors[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TutorDetailsLearner(tutorData: tutorData),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                       CircleAvatar(
                  radius: 30,
                  backgroundImage: imageTutorUrl!= null
                      ? NetworkImage("${tutorData['profileImage']}")
                      : AssetImage("images/default_avatar.png") as ImageProvider<Object>?,
                ),
                        Text(
                          "${tutorData['name']}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          "${tutorData['subject']}",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 12,
                            ),
                            Text(
                              "4.9",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),


      // Messages Screen
      MessageScreenForLearners(),

      // Schedule Screen
      VideoList(),

      // Settings Screen
      LearnerSettingsScreen(),
    ];
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      // Add the Bottom Navigation Bar at the bottom of HomeScreen

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
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble_text_fill),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_collection),
              label: "Videos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Setting",
            ),
          ],
        ),
      ),
    );
  }
}