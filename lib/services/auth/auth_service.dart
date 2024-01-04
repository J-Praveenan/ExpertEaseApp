import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  // instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // sign user in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);



      // add a new document for the user in users collection if it doesn't already exists
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
       
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));
      // Check if the user has the expected role
   
      
    

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
}
