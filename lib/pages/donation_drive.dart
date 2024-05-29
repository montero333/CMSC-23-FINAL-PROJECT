import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/donation_drive_model.dart';
import '../providers/donation_drive_provider.dart';

class ManageDonationDrivesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Donation Drives'),
      ),
      body: DonationDriveList(),
    );
  }
}

class DonationDriveList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final donationDriveProvider = Provider.of<DonationDriveProvider>(context);
    final donationDrives = donationDriveProvider.donationDrives;

    return ListView.builder(
      itemCount: donationDrives.length,
      itemBuilder: (context, index) {
        final donationDrive = donationDrives[index];
        return ListTile(
          title: Text(donationDrive.title),
          subtitle: Text('Total Donations: ${donationDrive.totalDonations}'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Implement deletion logic
            },
          ),
          onTap: () {
            // Navigate to update donation drive screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateDonationDriveScreen(donationDrive: donationDrive),
              ),
            );
          },
        );
      },
    );
  }
}

class UpdateDonationDriveScreen extends StatelessWidget {
  final DonationDrive donationDrive;

  const UpdateDonationDriveScreen({Key? key, required this.donationDrive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement UI to update donation drive
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Donation Drive'),
      ),
      body: Center(
        child: Text('Update Donation Drive Screen'),
      ),
    );
  }
}

// You can similarly create screens for adding donation drives and selecting available donations
