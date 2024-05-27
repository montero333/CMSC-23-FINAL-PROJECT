import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/firebase_auth_api.dart';

class MyAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> uStream;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? userObj;

  MyAuthProvider() {
    authService = FirebaseAuthAPI();
    fetchAuthentication();
  }

  Stream<User?> get userStream => uStream;
  User? get user => authService.getUser();
  String? get userID => authService.getUser()?.uid;

  void fetchAuthentication() {
    uStream = authService.userSignedIn();
    notifyListeners();
  }

  String getCurrentUserID() {
    return authService.current;
  }

  Future<String> signUp(
    String email, 
    String firstName,
    String lastName,
    String password,
    String address,
    String contactNumber,
    String userRole) async {
    String id = await authService.signUp(
      email, 
      firstName, 
      lastName, 
      password, 
      address, 
      contactNumber, 
      userRole); //await authService.signUp(email, password);
    notifyListeners();
    return id;
  }

   Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Sign-in failed: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }
}
