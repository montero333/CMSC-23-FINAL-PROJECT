import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/donation_drive_model.dart';
import '../api/firebase_drive_donation_api.dart';

class DonationDriveProvider with ChangeNotifier {
  final FirebaseDonationDriveAPI _firestoreService = FirebaseDonationDriveAPI();
  late Stream<QuerySnapshot> _donationDrives;

  Stream<QuerySnapshot> get donationDrives => _donationDrives;

  void fetchDonationDrives(String? orgID) {
    _donationDrives = _firestoreService.getDonationDrivesByOrgID(orgID);
    notifyListeners();
  }

  Future<void> addDonationDrive(DonationDrive donationDrive) async {
    await _firestoreService.addDonationDrive(donationDrive.toJson(donationDrive));
    notifyListeners();
  }


  // Future<void> removeDonationDrive(String id) async {
  //   await _firestoreService.deleteDonationDrive(id);
  //   _donationDrives.removeWhere((dd) => dd.id == id);
  //   notifyListeners();
  // }

  // Future<void> addDonationToDrive(String driveId, String donationId) async {
  //   await _firestoreService.addDonationToDrive(driveId, donationId);
  //   final index = _donationDrives.indexWhere((dd) => dd.id == driveId);
  //   if (index != -1 && !_donationDrives[index].donationIds!.contains(donationId)) {
  //     _donationDrives[index].donationIds!.add(donationId);
  //     notifyListeners();
  //   }
  // }

  // Future<void> removeDonationFromDrive(String driveId, String donationId) async {
  //   await _firestoreService.removeDonationFromDrive(driveId, donationId);
  //   final index = _donationDrives.indexWhere((dd) => dd.id == driveId);
  //   if (index != -1) {
  //     _donationDrives[index].donationIds!.remove(donationId);
  //     notifyListeners();
  //   }
  // }
}