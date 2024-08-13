import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  //instance of auth
  final FirebaseAuth auth = FirebaseAuth.instance;

// sign up
  Future<UserCredential> signUpWithEmailPassword(
      String? email, String? password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
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
