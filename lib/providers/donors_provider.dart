import 'package:flutter/material.dart';
import '../models/donor_model.dart';
import '../models/organization_model.dart';

class DonorsProvider with ChangeNotifier {
  final List<Donor> _donorList = [
    Donor("Aaron", 20000, 'Pending', Organization("JORDAN INC", 20000, "Donate to shoeless people")),
    Donor("Jamal", 20000, 'Pending', Organization("LOSBANOS INC", 20000, "Donate to homeless people")),
  ];

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
