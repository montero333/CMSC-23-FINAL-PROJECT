import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_drive_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<DonationDrive>> getDonationDrives() async {
    final QuerySnapshot snapshot = await _db.collection('donation_drives').get();
    return snapshot.docs.map((doc) => DonationDrive.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  // Method to stream all donation drives
  Stream<List<DonationDrive>> streamDonationDrives() {
    return _db.collection('donation_drives').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => DonationDrive.fromJson(doc.data())).toList());
  }


  Future<void> createDonationDrive(DonationDrive donationDrive) async {
    await _db.collection('donation_drives').doc(donationDrive.id).set(donationDrive.toJson());
  }

  Future<void> updateDonationDrive(DonationDrive donationDrive) async {
    await _db.collection('donation_drives').doc(donationDrive.id).update(donationDrive.toJson());
  }


  Future<void> deleteDonationDrive(String id) {
    return _db.collection('donation_drives').doc(id).delete();
  }

  Future<void> addDonationToDrive(String driveId, String donationId) {
    return _db.collection('donation_drives').doc(driveId).update({
      'donationIds': FieldValue.arrayUnion([donationId]),
    });
  }

  Future<void> removeDonationFromDrive(String driveId, String donationId) {
    return _db.collection('donation_drives').doc(driveId).update({
      'donationIds': FieldValue.arrayRemove([donationId]),
    });
  }

  Future<List<String>?> getDonationIdsForDrive(String id) async {
    final DocumentSnapshot driveSnapshot = await _db.collection('donation_drives').doc(id).get();
    if (driveSnapshot.exists) {
      final data = driveSnapshot.data() as Map<String, dynamic>;
      final List<String>? donationIds = data['donationIds'] != null ? List<String>.from(data['donationIds']) : [];
      return donationIds;
    } else {
      return []; // Return an empty list if the donation drive doesn't exist or has no donation IDs
    }
  }
}
