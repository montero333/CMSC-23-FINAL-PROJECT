import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminViewDonors extends StatefulWidget {
  @override
  _AdminViewDonorsState createState() => _AdminViewDonorsState();
}

class _AdminViewDonorsState extends State<AdminViewDonors> {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('CredentialInfo');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Donors'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.where('userRole', isEqualTo: 'Donor').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No donors found.'));
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text('${data['firstName']} ${data['lastName']}'),
                subtitle: Text(data['email']),
              );
            },
          );
        },
      ),
    );
  }
}
