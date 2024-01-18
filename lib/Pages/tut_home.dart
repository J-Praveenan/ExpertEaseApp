import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_ease/Pages/setting_screen.dart';
import 'package:expert_ease/Pages/tutor_details_display.dart';
import 'package:expert_ease/Pages/tutor_vdo.dart';
import 'package:expert_ease/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class tutScreen extends StatefulWidget {
  @override
  State<tutScreen> createState() => _tutScreenState();
}

class _tutScreenState extends State<tutScreen> {
  int _selectedIndex = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: Stack(
        children: <Widget>[
          Container(
            // Here the height of the container is 45% of our total height
            height: size.height * .45,
            decoration: BoxDecoration(
              color: Color(0xFFF5CEB8),
              image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: Color(0xFFF2BEA1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset("assets/icons/menu.svg"),
                    ),
                  ),
                  Text(
                    "Hello ${user?.email ?? 'User'}",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  SearchBar(),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        CategoryCard(
                          title: "Diet Recommendation",
                          svgSrc: "assets/icons/Hamburger.svg",
                          press: () {},
                        ),
                        CategoryCard(
                          title: "Videos",
                          svgSrc: "assets/icons/Excrecises.svg",
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return TutVdo();
                              }),
                            );
                          },
                        ),
                        CategoryCard(
                          title: "About You",
                          svgSrc: "assets/icons/Meditation.svg",
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  // Pass the current user's data to TutorDetails
                                  return TutorDetails(tutorData: {
                                    'email': user?.email,
                                    // Add other user data fields as needed
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          title: "Yoga",
                          svgSrc: "assets/icons/yoga.svg",
                          press: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  final Function() press;
  const CategoryCard(
      {super.key,
      required this.svgSrc,
      required this.title,
      required this.press});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        // padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 17),
              blurRadius: 17,
              spreadRadius: -23,
              color: kShadowColor,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: press,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  SvgPicture.asset(svgSrc),
                  Spacer(),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: 15),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29.5),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search",
          icon: SvgPicture.asset("assets/icons/search.svg"),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      height: 80,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BottomNavItem(
            title: "Today",
            svgScr: "assets/icons/calendar.svg",
          ),
          BottomNavItem(
            title: "All Exercises",
            svgScr: "assets/icons/gym.svg",
            isActive: true,
          ),
          BottomNavItem(
              title: "Settings",
              svgScr: "assets/icons/Settings.svg",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      // Replace the following line with the actual widget for the "Settings" page
                      return SettingsScreen(); // Example: SettingsPage is the name of your settings page widget
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String svgScr;
  final String title;
  final Function()? press;
  final bool isActive;

  const BottomNavItem({
    Key? key,
    required this.svgScr, // Corrected parameter name
    required this.title,
    this.press,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Check if press is not null before invoking it
        if (press != null) {
          press!();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SvgPicture.asset(
            svgScr,
            color: isActive ? kActiveIconColor : kTextColor,
          ),
          Text(
            title,
            style: TextStyle(color: isActive ? kActiveIconColor : kTextColor),
          ),
        ],
      ),
    );
  }
}



































// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expert_ease/Pages/messages_screen.dart';
// import 'package:expert_ease/Pages/setting_screen.dart';
// import 'package:expert_ease/Pages/tutor_details_display.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class TutScreen extends StatefulWidget {
   

//   @override
//   State<TutScreen> createState() => _TutScreenState();
// }

// class _TutScreenState extends State<TutScreen> {
//   int _selectedIndex = 0;

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   User? user;
//   List<Map<String, dynamic>> tutors = [];

//   @override
//   void initState() {
//     super.initState();
//     user = _auth.currentUser;
//     loadTutors();
//   }

//   Future<void> loadTutors() async {
//     final QuerySnapshot tutorSnapshot = await _firestore
//         .collection('users')
//         .where('role', isEqualTo: 'Tutor')
//         .get();

//     setState(() {
//       tutors = tutorSnapshot.docs
//           .map((doc) => doc.data() as Map<String, dynamic>)
//           .toList();
//     });
//   }

//   List<String> symptoms = [
//     "ICT",
//     "Maths",
//     "English",
//     "Science",
//     "Web Development",
//   ];

//   List<String> imgs = [
//     "tutor1.jpeg",
//     "tutor2.jpeg",
//     "tutor3.jpeg",
//     "tutor4.jpeg",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     User? user = _auth.currentUser;

//     final _screens = [
//       SingleChildScrollView(
//         padding: EdgeInsets.only(top: 40),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Hello ${user?.email ?? 'User'}",
//                     style: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   CircleAvatar(
//                     radius: 25,
//                     backgroundImage: AssetImage("images/tutor1.jpeg"),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 5),
//             Container(
//               margin: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
//               padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//               decoration: BoxDecoration(
//                 color: Color(0xFFF0EEFA),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: TextFormField(
//                 decoration: InputDecoration(
//                   hintText: "Search for subject",
//                   border: InputBorder.none,
//                   suffixIcon: Icon(Icons.search),
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 InkWell(
//                   onTap: () {},
//                   child: Container(
//                     padding: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Color(0xFF7165D6),
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 6,
//                           spreadRadius: 4,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.add,
//                             color: Color(0xFF7165D6),
//                             size: 35,
//                           ),
//                         ),
//                         SizedBox(height: 30),
//                         Text(
//                           "Online Class",
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           "Make an Appointment",
//                           style: TextStyle(
//                             color: Colors.white54,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {},
//                   child: Container(
//                     padding: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 6,
//                           spreadRadius: 4,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Color(0xFFF0EEFA),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.home_filled,
//                             color: Color(0xFF7165D6),
//                             size: 35,
//                           ),
//                         ),
//                         SizedBox(height: 30),
//                         Text(
//                           "Onsite Class",
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           "Call the Tutor home",
//                           style: TextStyle(
//                             color: Colors.black54,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 25),
//             Padding(
//               padding: EdgeInsets.only(left: 15),
//               child: Text(
//                 "What are your preferred subjects?",
//                 style: TextStyle(
//                   fontSize: 23,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black54,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 70,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemCount: symptoms.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                     padding: EdgeInsets.symmetric(horizontal: 25),
//                     decoration: BoxDecoration(
//                       color: Color(0xFFF4F6FA),
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 4,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: Text(
//                         symptoms[index],
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 15),
//             Padding(
//               padding: EdgeInsets.only(left: 15),
//               child: Text(
//                 "Popular Tutors",
//                 style: TextStyle(
//                   fontSize: 23,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black54,
//                 ),
//               ),
//             ),
//             GridView.builder(
//               gridDelegate:
//                   SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//               itemCount: tutors.length,
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 Map<String, dynamic> tutorData = tutors[index];

//                 return InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => TutorDetails(tutorData: tutorData),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     margin: EdgeInsets.all(10),
//                     padding: EdgeInsets.symmetric(vertical: 15),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 4,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         CircleAvatar(
//                           radius: 35,
//                           backgroundImage: AssetImage("images/${imgs[index]}"),
//                         ),
//                         Text(
//                           "${tutorData['email']}",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         Text(
//                           "ICT",
//                           style: TextStyle(
//                             color: Colors.black45,
//                           ),
//                         ),
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.star,
//                               color: Colors.amber,
//                             ),
//                             Text(
//                               "4.9",
//                               style: TextStyle(
//                                 color: Colors.black45,
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),

//       // Home Screen

//       // Messages Screen
//       MessageScreen(),

//       // Schedule Screen
//       Container(),

//       // Settings Screen
//       SettingsScreen(),
//     ];
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _screens,
//       ),

//       // Add the Bottom Navigation Bar at the bottom of HomeScreen

//       bottomNavigationBar: Container(
//         height: 80,
//         child: BottomNavigationBar(
//           backgroundColor: Colors.white,
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: Color(0xFF7165D6),
//           unselectedItemColor: Colors.black26,
//           selectedLabelStyle: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 15,
//           ),
//           currentIndex: _selectedIndex,
//           onTap: (index) {
//             setState(() {
//               _selectedIndex = index;
//             });
//           },
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home_filled),
//               label: "Home",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(CupertinoIcons.chat_bubble_text_fill),
//               label: "Chat",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.calendar_month),
//               label: "Schedule",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.settings),
//               label: "Setting",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
