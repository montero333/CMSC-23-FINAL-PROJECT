// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_drive_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createDonationDrive(DonationDrive donationDrive) {
    return _db.collection('donation_drives').doc(donationDrive.id).set(donationDrive.toMap());
  }

  Future<void> updateDonationDrive(DonationDrive donationDrive) {
    return _db.collection('donation_drives').doc(donationDrive.id).update(donationDrive.toMap());
  }

  Future<void> deleteDonationDrive(String id) {
    return _db.collection('donation_drives').doc(id).delete();
  }

  Future<List<DonationDrive>> getDonationDrives() async {
    final snapshot = await _db.collection('donation_drives').get();
    return snapshot.docs.map((doc) => DonationDrive.fromMap(doc.data())).toList();
  }
}
