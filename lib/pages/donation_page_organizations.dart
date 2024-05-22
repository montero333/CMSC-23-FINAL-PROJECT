import 'package:flutter/material.dart';
import 'package:milestone_1/pages/donateTo_OrganizationPage.dart';
import 'package:provider/provider.dart';

import '../models/organization_model.dart';
import '../providers/organizations_provider.dart';
import 'OrganizationInfoPage.dart';

class DonationOrganizationsList extends StatefulWidget {
  const DonationOrganizationsList({super.key});

  _DonationOrganizationsListState createState() => _DonationOrganizationsListState();
}

class _DonationOrganizationsListState extends State<DonationOrganizationsList> {
  // Replace with your actual data

  @override
  Widget build(BuildContext context) {
    final List<Organization> organizations = context.watch<OrganizationsProvider>().organizationsList;
    final List<OrganizationCardData> data = [
      OrganizationCardData(title: organizations[0].name, description: organizations[0].description),
      OrganizationCardData(title: organizations[1].name, description: organizations[1].description),
      // ... add more data objects
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Organizations"),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          Organization organization = organizations[index];
          final cardData = data[index];
          return GestureDetector(
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DonateToOrganization(organization: organization),))
            },
            child: OrganizationCard(data: cardData)
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
  final OrganizationCardData data;

  const OrganizationCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              data.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(data.description),
          ],
        ),
      ),
    );
  }
}
