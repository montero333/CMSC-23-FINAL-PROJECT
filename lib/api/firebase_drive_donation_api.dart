import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_drive_model.dart';

class FirebaseDonationDriveAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getDonationDrivesByOrgID(String? orgID) {
    return db.collection("donation_drives").where("orgID", isEqualTo: orgID).snapshots();
  }

  Future<String> addDonationDrive(Map<String, dynamic> donationDrive) async {
    try {
      await db.collection('donation_drives').add(donationDrive);
      return "Successfully added donation!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<void> updateDonationDrive(DonationDrive donationDrive) async {
    await db.collection('donation_drives').doc(donationDrive.id).update(donationDrive.toJson(donationDrive));
  }


  Future<void> deleteDonationDrive(String id) {
    return db.collection('donation_drives').doc(id).delete();
  }

}
