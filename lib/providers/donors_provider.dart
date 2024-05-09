import 'package:flutter/material.dart';
import '../models/donor_model.dart';


class DonorsProvider with ChangeNotifier {
  final List<Donor> _donorList = [
    Donor("Aaron", 20000),
    Donor("Jamal", 20000)
  ];
  
  List<Donor> get donorsList => _donorList;

  void addDonor(Donor donor) {
    _donorList.add(donor);
    notifyListeners();
  }

  void removeAll() {
    _donorList.clear();
    notifyListeners();
  }

}
