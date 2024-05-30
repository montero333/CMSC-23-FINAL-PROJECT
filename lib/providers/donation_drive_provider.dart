import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/donation_drive_model.dart';
import '../api/firebase_drive_donation_api.dart';

class DonationDriveProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<DonationDrive> _donationDrives = [];

  List<DonationDrive> get donationDrives => _donationDrives;

  Future<void> fetchDonationDrives() async {
    _donationDrives = await _firestoreService.getDonationDrives();
    notifyListeners();
  }

  Future<void> addDonationDrive(DonationDrive donationDrive, List<File> imageFiles) async { // Changed to List<File>
    List<String> imageUrls = [];

    for (File imageFile in imageFiles) {
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('donation_drive_images')
          .child('${donationDrive.id}_${imageFiles.indexOf(imageFile)}.jpg'); // Unique name for each image
      final uploadTask = storageReference.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    donationDrive.imageUrls = imageUrls;
    await _firestoreService.createDonationDrive(donationDrive);
    _donationDrives.add(donationDrive);
    notifyListeners();
  }

  Future<void> updateDonationDrive(DonationDrive donationDrive) async {
    await _firestoreService.updateDonationDrive(donationDrive);
    final index = _donationDrives.indexWhere((dd) => dd.id == donationDrive.id);
    if (index != -1) {
      _donationDrives[index] = donationDrive;
      notifyListeners();
    }
  }

  Future<void> removeDonationDrive(String id) async {
    await _firestoreService.deleteDonationDrive(id);
    _donationDrives.removeWhere((dd) => dd.id == id);
    notifyListeners();
  }
}
