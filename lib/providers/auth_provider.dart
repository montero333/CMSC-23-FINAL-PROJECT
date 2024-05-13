import 'package:flutter/material.dart';
import '../models/auth.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final Auth _auth = Auth();
  bool _isLoggedIn = false;
  bool _isAdmin = false; // Property to indicate admin status
  Map<String, Map<String, dynamic>> _userData = {}; // Map to store user data

  bool get isLoggedIn => _isLoggedIn;
  bool get isAdmin => _isAdmin; // Getter for isAdmin

  Future<bool> signUp(String name, String username, String password, List<String> addresses, String contactNo) async {
    bool success = await _auth.signUp(User(name: name, username: username, password: password, addresses: addresses, contactNo: contactNo));
    if (success) {
      _isLoggedIn = true;
      // Save user data in the map
      _userData[username] = {
        'name': name,
        'password': password,
        'addresses': addresses,
        'contactNo': contactNo,
      };
      print('User data updated: $_userData'); // Print the user data after updating
      // Check if the signed-up user is an admin
      _isAdmin = username == 'admin'; // Example: Check if username is 'admin'
      notifyListeners();
    }
    return success;
  }

  Future<bool> login(String username, String password) async {
    bool success = await _auth.login(username, password); // Assuming username is used for login
    if (success) {
      _isLoggedIn = true;
      // Check if the logged-in user is an admin
      _isAdmin = username == 'admin'; // Example: Check if username is 'admin'
      notifyListeners();
    }
    return success;
  }

  void logout() {
    _isLoggedIn = false;
    _isAdmin = false; // Reset isAdmin on logout
    notifyListeners();
  }

  bool checkCredentials(String username, String password) {
    if (_userData.containsKey(username)) {
      // Check if the entered password matches the stored password for the username
      return _userData[username]?['password'] == password;
    }
    return false; // Username not found
  }
}
