import 'package:cloud_firestore/cloud_firestore.dart';
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
    Stream<QuerySnapshot> organizations = context.watch<OrganizationProvider>().organizations;

    return Scaffold(
      drawer: AppDrawer() ,
      appBar: AppBar(
        title: Text("List of Organizations"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder(
          stream: organizations, 
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error encountered! ${snapshot.error}"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData) {
              return const Row(
                mainAxisAlignment: MainAxisAlignment.center, //return no friends message
                children: [
                  Text(
                    "No friends ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Icon(Icons.sentiment_dissatisfied_rounded ,color: Colors.white,),
                ],
              );
            }
      
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Organization organization = Organization.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>
                );
                organization.id = snapshot.data?.docs[index].id;
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DonationDriveList(organizationID: organization.id,),))
                  },
                  child: OrganizationCard(organization: organization)
                );
              },
            );
      
      
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
            Text(organization.description ??  "No Org"),
          ],
        ),
      ),
    );
  }
}
