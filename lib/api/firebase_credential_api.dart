import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class FirebaseCredAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('CredentialInfo');

  Future<DocumentSnapshot> getUserByEmail(String email) async {
    QuerySnapshot querySnapshot = await usersCollection.where('email', isEqualTo: email).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      throw Exception('User not found');
    }
  }

  //method to get user by ID
  Future<DocumentSnapshot> getUserByUserID(String? userId) async {
    QuerySnapshot querySnapshot = await usersCollection.where('userId', isEqualTo: userId).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      throw Exception('User not found');
    }
  }


  Future<String> addUser(Map<String, dynamic> user) async {
    // Check if the email already exists
    bool emailExists = await checkIfEmailExistsInDatabase(user['email']);
    if (emailExists) {
      return "This email is already in use";
    }

    try {
      final docRef = await db.collection("CredentialInfo").add(user);
      await db.collection("CredentialInfo").doc(docRef.id).update({'id': docRef.id});

      return "Successfully added user!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<bool> checkIfEmailExistsInDatabase(String email) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection("CredentialInfo")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking email existence in database: $e");
      return false;
    }
  }

  Future<bool> checkIfOrganizationNameExists(String organizationName) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection("CredentialInfo")
          .where("organizationName", isEqualTo: organizationName)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking organization name existence in database: $e");
      return false;
    }
  }

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("CredentialInfo").snapshots();
  }

  Future<void> uploadProof({
    required TextEditingController proofsController,
    required List<String> selectedImages,
    required Function setStateCallback,
  }) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      try {
        // Upload the selected image to Firebase Storage
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('proofs')
            .child('proof_${DateTime.now().millisecondsSinceEpoch}.jpg');

        await ref.putFile(File(image.path));

        // Once uploaded, you can get the download URL of the image
        String downloadURL = await ref.getDownloadURL();

        // Update the proofsController text field with the download URL
        setStateCallback(() {
          proofsController.text = downloadURL;
          selectedImages.add(image.path); // Add selected image path to the list
        });
      } catch (e) {
        print('Error uploading proof image to Firebase Storage: $e');
      }
    } else {
      // User canceled the operation
      print('No image selected.');
    }
  }

  void removeImage({
    required int index,
    required List<String> selectedImages,
    required Function setStateCallback,
  }) {
    setStateCallback(() {
      selectedImages.removeAt(index);
    });
  }

  Future<void> showToast(String message) async {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  
}
