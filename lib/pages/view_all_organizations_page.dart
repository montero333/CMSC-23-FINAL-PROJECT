import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:montero_cmsc23/models/organization_model.dart';
import 'package:montero_cmsc23/providers/organizations_provider.dart';
import 'package:provider/provider.dart';
import '../api/firebase_credential_api.dart';
import 'organization_details_page.dart';

class ViewAllOrganizationsPage extends StatefulWidget {
  @override
  _ViewAllOrganizationsPageState createState() =>
      _ViewAllOrganizationsPageState();
}

class _ViewAllOrganizationsPageState extends State<ViewAllOrganizationsPage> {
  final FirebaseCredAPI _firebaseCredAPI = FirebaseCredAPI();
  bool _showOnlyNotApproved = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Organizations'),
        actions: [
          IconButton(
            icon: Icon(
                _showOnlyNotApproved ? Icons.filter_alt_off : Icons.filter_alt),
            onPressed: () {
              setState(() {
                _showOnlyNotApproved = !_showOnlyNotApproved;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _showOnlyNotApproved
            ? _firebaseCredAPI.usersCollection
                .where('userRole', isEqualTo: 'Organization')
                .where('isApproved', isEqualTo: false)
                .snapshots()
            : _firebaseCredAPI.usersCollection
                .where('userRole', isEqualTo: 'Organization')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No organizations found.'));
          }

          final organizations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: organizations.length,
            itemBuilder: (context, index) {
              final org = organizations[index];
              return ListTile(
                title: Text(org['organizationName'] ?? 'Unnamed Organization'),
                subtitle: Text(org['email']),
                onTap: () {
                  context.read<OrganizationProvider>().addOrganization(
                      Organization(
                          id: organizations[index].id,
                          name: organizations[index]["organizationName"],
                          description: organizations[index]["email"],
                          donations: [],
                          status: true));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrganizationDetailsPage(
                        organization: org,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
