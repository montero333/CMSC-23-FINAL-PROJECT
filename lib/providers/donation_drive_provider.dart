// lib/providers/donation_drive_provider.dart
import 'package:flutter/material.dart';
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

  Future<void> addDonationDrive(DonationDrive donationDrive) async {
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
