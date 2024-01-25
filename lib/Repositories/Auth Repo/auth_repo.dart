import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart'; // Eklediğimiz kütüphane

class AuthRepo {
  final _auth = FirebaseAuth.instance;

  String? errorText; // Hata mesajlarını tutacak değişken

  Future<User?> createUserWithUsernamePassword(String email, String password) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credentials.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorText = 'Your Password Is Too Weak.';
      } else if (e.code == 'email-already-in-use') {
        errorText = 'This E-Mail Is Already Being Used.';
      }
      return null;
    }
  }

  Future<User?> loginWithUsernamePassword(String email, String password) async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credentials.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        // Handle specific authentication errors with custom messages
        errorText = 'Invalid email or password. Please check your credentials and try again.';
      } else if (e.code == 'invalid-email') {
        // Handle badly formatted email address error
        errorText = 'The email address is badly formatted. Please enter a valid email address.';
      } else {
        // Handle other FirebaseAuthException errors
        errorText = 'Authentication failed. Error: ${e.message}';
      }
      print(errorText);
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      errorText = 'Error sending reset password email: ${e.message}';
      // throw e; // Eğer hata ile başa çıkamayacaksanız bu satırı ekleyebilirsiniz
    }
  }

  Future<User?> signinWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credentials = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final userCredential = await _auth.signInWithCredential(credentials);
      return userCredential.user;
    } catch (e) {
      errorText = 'Error signing in with Google: $e';
      return null;
    }
  }

  // Hata mesajlarını döndüren metod
  String? getErrorText() {
    return errorText;
  }
}
