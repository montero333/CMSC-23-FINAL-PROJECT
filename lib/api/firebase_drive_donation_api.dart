import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_drive_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createDonationDrive(DonationDrive donationDrive) async {
    await _db.collection('donation_drives').doc(donationDrive.id).set(donationDrive.toJson());
  }

  Future<void> updateDonationDrive(DonationDrive donationDrive) {
    return _db.collection('donation_drives').doc(donationDrive.id).update(donationDrive.toJson());
  }

  Future<void> deleteDonationDrive(String id) {
    return _db.collection('donation_drives').doc(id).delete();
  }

  Future<List<DonationDrive>> getDonationDrives() async {
    final snapshot = await _db.collection('donation_drives').get();
    return snapshot.docs.map((doc) => DonationDrive.fromJson(doc.data())).toList();
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
}
