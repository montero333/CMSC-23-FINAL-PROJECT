import 'package:flutter/material.dart';
import '../models/donation_drive_model.dart';
import '../models/donor_model.dart';  // Assuming you have the Donor class in this file

class DonationDriveProvider with ChangeNotifier {
  List<DonationDrive> _donationDrives = [];

  List<DonationDrive> get donationDrives => _donationDrives;

  void addDonationDrive(DonationDrive donationDrive) {
    _donationDrives.add(donationDrive);
    notifyListeners();
  }

  void addDonorToDrive(Donor donor, DonationDrive donationDrive) {
    final drive = _donationDrives.firstWhere((d) => d == donationDrive);
    drive.addDonor(donor);
    notifyListeners();
  }

  double getTotalDonationsForDrive(DonationDrive donationDrive) {
    return donationDrive.totalDonations;
  }
}
