import 'package:expert_ease/Pages/learner_home_page.dart';
import 'package:expert_ease/Pages/learner_home.dart';
import 'package:expert_ease/Pages/tut_home.dart';
import 'package:expert_ease/services/auth/auth_service.dart';
import 'package:expert_ease/services/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Pages/video_upload.dart';
import '../../Pages/learner_home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              return FutureBuilder(
                future: AuthService().getUserRole(user.uid),
                builder: (context, roleSnapshot) {
                  if (roleSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (roleSnapshot.hasData) {
                    String userRole = roleSnapshot.data.toString();
                    if (userRole == 'Tutor') {
                      return  tutScreen();
                    } else if (userRole == 'Learner') {
                      return  LearnerHomeScreen();
                    }
                  }
return const LoginOrRegister();
                 // return const HomePage(); // Fallback to HomePage if role not determined
                },
              );
            }
          }

          return const LoginOrRegister();
        },
      ),
    );
  }
}
