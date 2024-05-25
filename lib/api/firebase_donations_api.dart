import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonationsAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonation(Map<String, dynamic> donation) async { //add to firebase
    try {
      await db.collection("friends").add(donation);
      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

}
