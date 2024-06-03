import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../providers/donation_drive_provider.dart';
import '../pages/donateTo_OrganizationPage.dart';
import 'package:provider/provider.dart';
import '../models/donation_drive_model.dart';
import '../models/organization_model.dart';
import '../providers/auth_provider.dart';
import '../providers/organizations_provider.dart';
import 'OrganizationInfoPage.dart';

class DonationDriveList extends StatefulWidget {
  // final List<DonationDrive> donationDrives;
  final String? organizationID;

  const DonationDriveList({super.key, required this.organizationID});

  _DonationDriveListState createState() => _DonationDriveListState();
}

class _DonationDriveListState extends State<DonationDriveList> {

  @override
  void initState() {
    super.initState();
    if (widget.organizationID != null) {
      context.read<DonationDriveProvider>().fetchDonationDrives(widget.organizationID);
    }
  }

  @override
  Widget build(BuildContext context) {

    // if (widget.organizationID != null) {
    // context.watch<DonationDriveProvider>().fetchDonationDrives("qOeJC0zYiEWpAoe9uclC");
    Stream<QuerySnapshot> donationDrives = context.watch<DonationDriveProvider>().donationDrives;
      return Scaffold(
        appBar: AppBar(
          title: Text("List of Donation Drives"),
          backgroundColor: Colors.green,
        ),
        body: StreamBuilder(
          stream: donationDrives, 
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error encountered! ${snapshot.error}"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No Todos Found"),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                DonationDrive donationDrive = DonationDrive.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>
                );
                return GestureDetector(
                onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DonateToOrganizationDrive(donationDrive: donationDrive, userID: context.watch<MyAuthProvider>().userID),))
                },
                child: DonationDriveCard(donationDrive: donationDrive)
                );
              },
            );
          },
        )
      );
  }
}


class DonationDriveCard extends StatelessWidget {
  final DonationDrive donationDrive;

  const DonationDriveCard({super.key, required this.donationDrive});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              donationDrive.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(donationDrive.description),
          ],
        ),
      ),
    );
  }
}