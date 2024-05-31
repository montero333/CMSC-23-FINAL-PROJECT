import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:montero_cmsc23/models/donation_drive_model.dart';
import 'package:provider/provider.dart';
import '../providers/donation_drive_provider.dart';
import 'drive_form.dart';
import 'edit_donation_drive.dart';

class DonationDrivesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Drives'),
      ),
      body: StreamBuilder<List<DonationDrive>>(
        stream: Provider.of<DonationDriveProvider>(context).donationDriveStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final donationDrives = snapshot.data ?? [];
            return ListView(
              children: donationDrives.map((donationDrive) {
                return Card(
                  child: ListTile(
                    title: Text(donationDrive.title),
                    subtitle: Text(donationDrive.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditDonationDriveForm(donationDrive: donationDrive),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateDonationDriveForm()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
