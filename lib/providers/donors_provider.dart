import 'package:flutter/material.dart';
import '../models/donor_model.dart';

class DonorsProvider with ChangeNotifier {
  final List<Donor> _donorList = [];

  List<Donor> get donorsList => _donorList;

  void addDonor(Donor donor) {
    _donorList.add(donor);
    notifyListeners();
  }

  void updateDonorStatus(int index, String newStatus) {
    _donorList[index].status = newStatus;
    notifyListeners();
  }

  void removeAll() {
    _donorList.clear();
    notifyListeners();
  }
}
