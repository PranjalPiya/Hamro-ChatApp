import 'package:chatapp/components/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  //creating a firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //get users
  Stream<List<Map<String, dynamic>>> getAllUsers() {
    return _firebaseFirestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //create individual user
        final user = doc.data();
        //return user
        return user;
      }).toList();
    });
  }

// Get current user from Firestore

  //send message

  // get messages
}
