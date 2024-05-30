import 'package:flutter/material.dart';
import 'package:montero_cmsc23/pages/drawer.dart';
import 'package:montero_cmsc23/providers/donation_drive_provider.dart';
import '../pages/donation_drive_list.dart';
import 'package:provider/provider.dart';
import '../models/organization_model.dart';
import '../providers/organizations_provider.dart';

class DonationOrganizationsList extends StatefulWidget {
  const DonationOrganizationsList({super.key});

  _DonationOrganizationsListState createState() => _DonationOrganizationsListState();
}

class _DonationOrganizationsListState extends State<DonationOrganizationsList> {
  // Replace with your actual data

  @override
  Widget build(BuildContext context) {
    final List<Organization> organizations = context.watch<OrganizationProvider>().organizations;

    return Scaffold(
      drawer: AppDrawer() ,
      appBar: AppBar(
        title: Text("List of Organizations"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: organizations.length,
        itemBuilder: (context, index) {
          Organization organization = organizations[index];
          return GestureDetector(
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DonationDrivesPage(),))
            },
            child: OrganizationCard(organization: organization)
            ); // Pass data to your card widget
        },
      ),
    );
  }
}

class OrganizationCardData {
  final String title;
  final String description;

  OrganizationCardData({required this.title, required this.description});
}

class OrganizationCard extends StatelessWidget {
  final Organization organization;

  const OrganizationCard({super.key, required this.organization});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              organization.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(organization.description),
          ],
        ),
      ),
    );
  }
}
