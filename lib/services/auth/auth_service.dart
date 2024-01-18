import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_ease/Pages/learner_home.dart';
import 'package:expert_ease/Pages/tut_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../Pages/vdo.dart';
import '../../Pages/learner_home.dart';

class AuthService extends ChangeNotifier {
  // instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc = await _fireStore.collection('users').doc(uid).get();
      return userDoc['role'];
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }


  // get current user ------------------------------------------------------------------------------
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;}
  // sign user in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password,BuildContext context,void Function(BuildContext, Widget) navigate) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);



      // add a new document for the user in users collection if it doesn't already exists
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
       
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));
      // Check if the user has the expected role
   
      DocumentSnapshot userDoc = await _fireStore.collection('users').doc(userCredential.user!.uid).get();
      String userRole = userDoc['role'];

      // Navigate based on user role
        if (userRole == 'Tutor') {
        navigate(context, tutScreen());
      } else if (userRole == 'Learner') {
        navigate(context, LearnerHomeScreen());
      }
    

      return userCredential;
    }
    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }

   
  }

  // create a new user
  Future<UserCredential> signUpWithEmailAndPassword(
      String role, String email, String password) async {
    try {
       print('Role: $role, Email: $email, Password: $password');
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
      
        email: email,
        password: password,
      );

      // after creating the user, create a new document for the user in the users collection
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'role': role,
        'uid': userCredential.user!.uid,
        'email': email,
      });



      return userCredential;
    } on FirebaseAuthException catch (e) {
       print('Firebase Auth Exception: ${e.code}');
      throw Exception(e.code);
    }
  }

  // sign user out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  // create a new userProgile
  Future<void> createNewUserProfile(String name, String address, String bio,
      String subject, String medium, Uint8List? image) async {
    try {
      User? user = getCurrentUser();

      if (user != null) {
        // Upload the image to Firebase Storage
        String imageFileName =
            'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(imageFileName);
        UploadTask uploadTask = storageReference.putData(image!);
        await uploadTask.whenComplete(() async {
          // Get the URL of the uploaded image
          String imageUrl = await storageReference.getDownloadURL();

          // Create a new document for the user in the userNewProfile collection
          await _fireStore.collection('userNewProfile').doc(user.uid).set({
            'uid': user.uid,
            'name': name,
            'address': address,
            'bio': bio,
            'subject': subject,
            'medium': medium,
            'profileImage':
                imageUrl, // Store the image URL in the Firestore database
          });
        });
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print('Error creating user profile: $e');
      throw Exception("Failed to create user profile");
    }
  }
}
