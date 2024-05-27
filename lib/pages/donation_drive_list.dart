import 'package:flutter/material.dart';
import 'package:milestone_1/pages/donateTo_OrganizationPage.dart';
import 'package:provider/provider.dart';

import '../models/donation_drive_model.dart';
import '../models/organization_model.dart';
import '../providers/organizations_provider.dart';
import 'OrganizationInfoPage.dart';

class DonationDriveList extends StatefulWidget {
  final List<DonationDrive> donationDrives;

  const DonationDriveList({super.key, required this.donationDrives});

  _DonationDriveListState createState() => _DonationDriveListState();
}

class _DonationDriveListState extends State<DonationDriveList> {
  // Replace with your actual data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Donation Drives"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: widget.donationDrives.length,
        itemBuilder: (context, index) {
          DonationDrive donationDrive = widget.donationDrives[index];
          return GestureDetector(
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DonateToOrganizationDrive(donationDrive: donationDrive, userID: "user1",),))
            },
            child: DonationDriveCard(donationDrive: donationDrive)
            ); // Pass data to your card widget
        },
      ),
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
              donationDrive.name,
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
