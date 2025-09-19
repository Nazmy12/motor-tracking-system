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

  Future<String?> signUp(String email, String password, {String? name, String? phone}) async {
    try {
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Create user in Firestore
      if (result.user != null) {
        model.User newUser = model.User(
          id: result.user!.uid,
          name: name ?? '',
          email: email,
          phone: phone ?? '',
        );
        await FirestoreService().createUser(newUser);
      }
      return null; // Success
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    }
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

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final user = await FirestoreService().getUser(uid);
    return user?.toJson();
  }
}
