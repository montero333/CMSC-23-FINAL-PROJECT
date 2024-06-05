import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/organization_model.dart';

class OrganizationAPI {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final String _collectionName = 'organizations';

  Future<String> addOrganization(Map<String, dynamic> organization) async { //add to firebase
    try {
      await db.collection(_collectionName).add(organization);
      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
  Stream<QuerySnapshot> getAllOrganizations() {
    return db.collection(_collectionName).snapshots();
  }


}
