import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  //instance of firebase and fire store
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // get current user
  User? getCurrentUser() {
    return auth.currentUser;
  }

// sign up
  Future<UserCredential> signUpWithEmailPassword(
      String? email, String? password, String? username) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      _firebaseFirestore.collection('Users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'username': username,
        'email': credential.user!.email,
      });
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

//sign in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// logout
  Future<void> logout() async {
    return auth.signOut();
  }
}
