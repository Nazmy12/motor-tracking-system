import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:gocheck/services/firestore_service.dart';
import 'package:gocheck/models/user.dart' as model;

class AuthProvider with ChangeNotifier {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  auth.User? _user;

  auth.User? get user => _user;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((auth.User? user) {
      _user = user;
      notifyListeners();
    });
  }


  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> logout() async {
    await signOut();
  }


  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    await FirestoreService().updateUser(uid, data);
  }

  Future<String?> signUp(
    String email,
    String password, {
    required String name,
    required String phone,
    required String nik,
    required String position,
  }) async {
    try {
      // Create Firebase Auth user
      auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore using NIK as document ID
      final user = model.User(
        id: nik, // Use NIK as document ID
        name: name,
        position: position,
        email: email,
        phone: phone,
      );

      await FirestoreService().createUser(user);

      return null; // Success
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An error occurred during signup';
    }
  }
}
