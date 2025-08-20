import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static Stream<User?> get userStream => _auth.authStateChanges();
  Auth._();
  static Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();
    GoogleSignInAccount? googleUser = await googleSignIn
        .attemptLightweightAuthentication();
    googleUser ??= await googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<void> logout() => _auth.signOut();

  static Future<void> resetPassword({required String email}) async {
    _auth.sendPasswordResetEmail(email: email);
  }
}
