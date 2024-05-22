import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCredAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addUser(Map<String, dynamic> user) async {
    try {
      final docRef = await db.collection("CredentialInfo").add(user);
      await db.collection("CredentialInfo").doc(docRef.id).update({'id': docRef.id});

      return "Successfully added user!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("CredentialInfo").snapshots();
  }
}
