import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/donation_drive_model.dart';
import '../api/firebase_drive_donation_api.dart';

class DonationDriveProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  late final Stream<List<DonationDrive>> _donationDriveStream = _firestoreService.streamDonationDrives(); // Initialize the stream
  List<DonationDrive> _donationDrives = [];

  List<DonationDrive> get donationDrives => _donationDrives;
  Stream<List<DonationDrive>> get donationDriveStream => _donationDriveStream;

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

  Future<void> addDonationToDrive(String driveId, String donationId) async {
    await _firestoreService.addDonationToDrive(driveId, donationId);
    final index = _donationDrives.indexWhere((dd) => dd.id == driveId);
    if (index != -1 && !_donationDrives[index].donationIds!.contains(donationId)) {
      _donationDrives[index].donationIds!.add(donationId);
      notifyListeners();
    }
  }

  Future<void> removeDonationFromDrive(String driveId, String donationId) async {
    await _firestoreService.removeDonationFromDrive(driveId, donationId);
    final index = _donationDrives.indexWhere((dd) => dd.id == driveId);
    if (index != -1) {
      _donationDrives[index].donationIds!.remove(donationId);
      notifyListeners();
    }
  }
}
