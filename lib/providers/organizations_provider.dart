import 'package:flutter/material.dart';
import '../models/organization_model.dart';
import '../api/firebase_organizations.dart';

class OrganizationProvider with ChangeNotifier {
  OrganizationApi _organizationApi = OrganizationApi();
  List<Organization> _organizations = [];
  bool _isLoading = false;

  List<Organization> get organizations => _organizations;
  bool get isLoading => _isLoading;

  Future<void> fetchOrganizations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _organizations = await _organizationApi.fetchOrganizations();
    } catch (error) {
      print(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrganization(Organization organization) async {
    try {
      final newOrganization = await _organizationApi.createOrganization(organization);
      _organizations.add(newOrganization);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateOrganization(Organization organization) async {
    try {
      final updatedOrganization = await _organizationApi.updateOrganization(organization);
      final index = _organizations.indexWhere((org) => org.id == organization.id);
      if (index != -1) {
        _organizations[index] = updatedOrganization;
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteOrganization(String id) async {
    try {
      await _organizationApi.deleteOrganization(id);
      _organizations.removeWhere((org) => org.id == id);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
