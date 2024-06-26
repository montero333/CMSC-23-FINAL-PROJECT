import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/credential_model.dart';
import '../api/firebase_credential_api.dart';

class CredProvider with ChangeNotifier {
  late FirebaseCredAPI firebaseService;
  late Stream<QuerySnapshot> _userStream;
  late FirebaseAuth _auth;

  late String email;
  late String firstName;
  late String lastName;
  late String _currentId;

  late String passWord;
  late String address;
  late String contactNumber;
  late String userRole;
  String? organizationName;
  String? proofs;

  String get getEmail => email;
  String get getFirst => firstName; 
  String get getLast => lastName; 
  String get currentID => _currentId;
  String get getPassword => passWord;

  String get getAddress => address;
  String get getContact => contactNumber;
  String get getUserRole => userRole;
  String? get getOrganizationName => organizationName;
  String? get getProofs => proofs;

  CredProvider() {
    firebaseService = FirebaseCredAPI();
    _auth = FirebaseAuth.instance;
    fetchUsers();
  }

  Future<String?> getCurrentUserId() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        _currentId = user.uid;
        return user.uid;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting current user ID: $e");
      return null;
    }
  }
  
  void changeId(String a) {
    _currentId = a;
  }


  Stream<QuerySnapshot> get users => _userStream;

  void fetchUsers() {
    _userStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  void addUser(Credential c) async {


    email = c.email;
    firstName = c.firstName;
    lastName = c.lastName;
    passWord = c.passWord;
    address = c.address;
    contactNumber = c.contactNumber;
    userRole = c.userRole;
    organizationName = c.organizationName;
    proofs = c.proofs;
    
    String message = await firebaseService.addUser(c.toJson());
    
    
    print(message);
    notifyListeners();
  }

   Future<String?> getUserRoleByEmail(String email) async {
    try {
      DocumentSnapshot userDoc = await firebaseService.getUserByEmail(email);
      userRole = userDoc['userRole'];
      notifyListeners();
      return userRole;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String,dynamic>?> getUserByID(String? userID) async {
    try {
      DocumentSnapshot userDoc = await firebaseService.getUserByUserID(userID);
      return {
        "firstName" : userDoc['firstName'],
        "lastName" : userDoc['lastName']
      };
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> isOrganizationApproved(String email) async {
  try {
    DocumentSnapshot userDoc = await firebaseService.getUserByEmail(email);
    String? userRole = userDoc['userRole'];
    bool isApproved = userDoc['isApproved'] ?? false;

    return userRole == 'Organization' && isApproved;
  } catch (e) {
    print('Error checking organization approval: $e');
    return false;
  }
}


  

}
