import 'package:flutter/material.dart';
import '../models/donation_drive_model.dart';
import '../models/organization_model.dart';


class OrganizationsProvider with ChangeNotifier {
  final List<Organization> _organizationList = [
    Organization("JORDAN INC", 20000, [
      DonationDrive("SHOE4EVERYONE", 0, "Donate to TAYTAY PEOPLE")
    ],"Donate to shoeless people"),
    Organization("LOSBANOS INC", 20000, [
      DonationDrive("Piso Mula Sa Puso", 0, "Tulungan ang mga tao makaahon")
    ], "Donate to the Los Banos People")
  ];
  
  List<Organization> get organizationsList => _organizationList;

  void addOrganization(Organization organization) {
    _organizationList.add(organization);
    notifyListeners();
  }

  void removeAll() {
    _organizationList.clear();
    notifyListeners();
  }

}
