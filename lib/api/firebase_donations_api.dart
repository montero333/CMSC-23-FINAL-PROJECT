import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonationsAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonation(Map<String, dynamic> donation) async { //add to firebase
    try {
      await db.collection("donations").add(donation);
      return "Successfully added donation!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> deleteDonation(String id) async {
    try {
      await db.collection("todos").doc(id).delete();

      return "Successfully deleted!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllDonationsByUserID(String? uid) {
    return db.collection("donations").where("userID", isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot> getAllDonationsByDriveID(String? driveID) {
    return db.collection("donations").where("driveID", isEqualTo: driveID).snapshots();
  }



}
