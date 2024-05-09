import 'package:flutter/material.dart';
import '../models/organization_model.dart';

class OrganizationsProvider with ChangeNotifier {
  final List<Organization> _organizationList = [
    Organization("JORDAN INC", 20000),
    Organization("LOSBANOS INC", 20000)
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
