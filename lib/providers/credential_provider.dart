import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/credential_model.dart';
import '../api/firebase_credential_api.dart';

class CredProvider with ChangeNotifier {
  late FirebaseCredAPI firebaseService;
  late Stream<QuerySnapshot> _userStream;

  late String userName;
  late String firstName;
  late String lastName;
  late String _currentId;

  late String passWord;
  late String address;
  late String contactNumber;
  late String userRole;

  String get getUserName => userName;
  String get getFirst => firstName; 
  String get getLast => lastName; 
  String get currentID => _currentId;
  String get getPassword => passWord;

  String get getAddress => address;
  String get getContact => contactNumber;
  String get getUserRole => userRole;

  CredProvider() {
    firebaseService = FirebaseCredAPI();
    fetchUsers();
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
    firstName = c.firstName;
    lastName = c.lastName;
    
    String message = await firebaseService.addUser(c.toJson(c));
    print(message);
    notifyListeners();
  }

}
