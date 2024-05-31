import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/organization_model.dart';

class OrganizationApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionName = 'organizations';

  Future<List<Organization>> fetchOrganizations() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection(_collectionName).get();
      return snapshot.docs
          .map((doc) => Organization.fromMap(doc.data()))
          .toList();
    } catch (error) {
      throw error.toString();
    }
  }

  Future<Organization> updateOrganization(Organization organization) async {
    try {
      await _db
          .collection(_collectionName)
          .doc(organization.id)
          .update(organization.toMap());
      return organization;
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> deleteOrganization(String id) async {
    try {
      await _db.collection(_collectionName).doc(id).delete();
    } catch (error) {
      throw error.toString();
    }
  }
}
