import 'package:flutter/material.dart';
import '../models/organization_model.dart';
import '../api/firebase_organizations.dart';

class OrganizationProvider with ChangeNotifier {
  late OrganizationAPI _organizationAPI;
  late List<Organization> _organizations;

  List<Organization> get organizations => _organizations;

  OrganizationProvider() {
    _organizationAPI = OrganizationAPI();
    _organizations = [];
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    try {
      _organizations = await _organizationAPI.getAllOrganizations();
      notifyListeners();
    } catch (e) {
      print('Error fetching organizations: $e');
    }
  }

  Future<void> addOrganization(Organization organization) async {
    try {
      String? message = await _organizationAPI.addOrganization(organization);
      if (message != null) {
        _organizations.add(organization);
        notifyListeners();
      } else {
        print('Failed to add organization');
      }
    } catch (e) {
      print('Error adding organization: $e');
    }
  }

  Future<void> updateOrganization(Organization organization) async {
    try {
      String? message = await _organizationAPI.updateOrganization(organization);
      if (message != null) {
        int index = _organizations.indexWhere((org) => org.id == organization.id);
        if (index != -1) {
          _organizations[index] = organization;
          notifyListeners();
        }
      } else {
        print('Failed to update organization');
      }
    } catch (e) {
      print('Error updating organization: $e');
    }
  }

  Future<void> deleteOrganization(String id) async {
    try {
      String? message = await _organizationAPI.deleteOrganization(id);
      if (message != null) {
        _organizations.removeWhere((org) => org.id == id);
        notifyListeners();
      } else {
        print('Failed to delete organization');
      }
    } catch (e) {
      print('Error deleting organization: $e');
    }
  }
}
