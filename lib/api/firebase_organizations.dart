import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/organization_model.dart';

class OrganizationAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'organizations';

  Future<String?> addOrganization(Organization organization) async {
    try {
      await _firestore.collection(_collectionName).doc(organization.id).set(organization.toJson());
      return 'Organization added successfully';
    } catch (e) {
      print('Error adding organization: $e');
      return null;
    }
  }

  Future<Organization?> getOrganizationById(String id) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection(_collectionName).doc(id).get();
      if (docSnapshot.exists) {
        return Organization.fromJson(docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting organization by ID: $e');
      return null;
    }
  }

  Future<List<Organization>> getAllOrganizations() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(_collectionName).get();
      return querySnapshot.docs.map((doc) => Organization.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting all organizations: $e');
      return [];
    }
  }

  Future<String?> updateOrganization(Organization organization) async {
    try {
      await _firestore.collection(_collectionName).doc(organization.id).update(organization.toJson());
      return 'Organization updated successfully';
    } catch (e) {
      print('Error updating organization: $e');
      return null;
    }
  }

  Future<String?> deleteOrganization(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
      return 'Organization deleted successfully';
    } catch (e) {
      print('Error deleting organization: $e');
      return null;
    }
  }
}
