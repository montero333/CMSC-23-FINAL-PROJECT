import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../models/organization_model.dart';
import '../providers/organizations_provider.dart';

class OrganizationDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot organization;

  OrganizationDetailsPage({required this.organization});

  Future<void> approveOrganization() async {
    try {
      await organization.reference.update({'isApproved': true});
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(organization['organizationName'] ?? 'Organization Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Organization Name: ${organization['organizationName'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Email: ${organization['email']}'),
              SizedBox(height: 8),
              Text('First Name: ${organization['firstName']}'),
              SizedBox(height: 8),
              Text('Last Name: ${organization['lastName']}'),
              SizedBox(height: 8),
              Text('Address: ${organization['address']}'),
              SizedBox(height: 8),
              Text('Contact Number: ${organization['contactNumber']}'),
              SizedBox(height: 8),
              Text('User Role: ${organization['userRole']}'),
              SizedBox(height: 8),
              Text('Proofs: ${organization['proofs'] ?? 'N/A'}'),
              SizedBox(height: 8),
              Text('Approved: ${organization['isApproved'] ? 'Yes' : 'No'}'),
              SizedBox(height: 16),
              organization['isApproved']
                  ? Text('This organization is already approved.')
                  : ElevatedButton(
                      onPressed: () async {
                        await approveOrganization();
                        Organization org = Organization.fromJson(
                          {
                            'id' : organization['id'],
                            'name': organization['organizationName'],
                            'description': null,
                            'status': true,
                          }
                        );
                        context.read<OrganizationProvider>().addOrganization(org);
                        Navigator.pop(context);
                      },
                      child: Text('Approve'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
