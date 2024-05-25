import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCredAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('CredentialInfo');


  Future<DocumentSnapshot> getUserByEmail(String email) async {
    QuerySnapshot querySnapshot = await usersCollection.where('email', isEqualTo: email).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      throw Exception('User not found');
    }
  }
Future<String> addUser(Map<String, dynamic> user) async {
  // Check if the email already exists
  bool emailExists = await checkIfEmailExistsInDatabase(user['email']);
  if (emailExists) {
    return "This email is already in use";
  }

  try {
    final docRef = await db.collection("CredentialInfo").add(user);
    await db.collection("CredentialInfo").doc(docRef.id).update({'id': docRef.id});

    return "Successfully added user!";
  } on FirebaseException catch (e) {
    return "Failed with error '${e.code}: ${e.message}";
  }
}

Future<bool> checkIfEmailExistsInDatabase(String email) async {
  try {
    QuerySnapshot querySnapshot = await db
        .collection("CredentialInfo")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print("Error checking email existence in database: $e");
    return false;
  }
}


  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("CredentialInfo").snapshots();
  }

  

  
}
