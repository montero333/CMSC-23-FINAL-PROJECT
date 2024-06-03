import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/organization_model.dart';
import '../api/firebase_organizations.dart';

class OrganizationProvider with ChangeNotifier {
  OrganizationAPI firebaseService = OrganizationAPI();
  late Stream<QuerySnapshot> _organizations;

  Stream<QuerySnapshot> get organizations => _organizations;

  OrganizationProvider() {
    fetchOrganizations();
  }

  void fetchOrganizations() {
      _organizations = firebaseService.getAllOrganizations();
      notifyListeners();
  }

  void addOrganization(Organization organization) async {  //add to firebase function
    await firebaseService.addOrganization(organization.toJson(organization));
    notifyListeners();
  }

  // Future<void> addOrganization(Organization organization) async {
  //   try {
  //     String? message = await firebaseService.addOrganization(organization.toJson(organization));
  //     if (message != null) {
  //       _organizations.add(organization);
  //       notifyListeners();
  //     } else {
  //       print('Failed to add organization');
  //     }
  //   } catch (e) {
  //     print('Error adding organization: $e');
  //   }
  // }

}
