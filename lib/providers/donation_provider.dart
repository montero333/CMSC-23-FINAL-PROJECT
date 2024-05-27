import 'package:flutter/material.dart';
import '../models/donation_model.dart';
import '../api/firebase_donations_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationProvider with ChangeNotifier {
  FirebaseDonationsAPI firebaseService = FirebaseDonationsAPI();
    late Stream<QuerySnapshot> _donationStream;

  // getter
  Stream<QuerySnapshot> get donationStream => _donationStream;
  
  void fetchDonationsByUserID(String? uid) { //get the donations of a user based on their uid
    _donationStream = firebaseService.getAllDonationsByUserID(uid);
    // notifyListeners();
  }

  void fetchDonationsByDriveID(String? driveID) { //get the donations of a drive based on their driveID
    _donationStream = firebaseService.getAllDonationsByDriveID(driveID);
    notifyListeners();
  }


  void addDonation(Donation donation) async {
    String message = await firebaseService.addDonation(donation.toJson(donation));
    print(message);
    notifyListeners();
  }

  void deleteDonation(String id) async {
    await firebaseService.deleteDonation(id);
    notifyListeners();
  }



}