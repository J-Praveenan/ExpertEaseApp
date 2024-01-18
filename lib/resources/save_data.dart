import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData(
      {required String name,
      required String bio,
      required String address,
      required String subject,
      required String medium,
      required Uint8List file}) async {
    String resp = "Some Error Occurred";
    try {

      if(name.isNotEmpty || bio.isNotEmpty){

      String imageUrl = await uploadImageToStorage('profileImage', file);
      await _firestore.collection('users').add({
        'name': name,
        'bio': bio,
        'address':address,
        'subject':subject,
        'medium':medium,
        'imageLink': imageUrl,
      });

      resp = 'success';
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}