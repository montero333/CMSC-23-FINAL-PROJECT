import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/firebase_auth_api.dart';

class MyAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> uStream;
  User? userObj;

  MyAuthProvider() {
    authService = FirebaseAuthAPI();
    fetchAuthentication();
  }

  Stream<User?> get userStream => uStream;

  void fetchAuthentication() {
    uStream = authService.getUser();
    notifyListeners();
  }

  String getCurrentUserID() {
    return authService.current;
  }

  Future<String> signUp(String email, String password) async {
    String id = await authService.signUp(email, password);
    notifyListeners();
    return id;
  }

  Future<void> signIn(String email, String password) async {
    await authService.signIn(email, password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }
}
