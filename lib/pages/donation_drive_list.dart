import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/donation_drive_provider.dart';
import 'drive_form.dart';

class DonationDrivesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Drives'),
      ),
      body: FutureBuilder(
        future: _initiate(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error initializing Firebase: ${snapshot.error}'));
          } else {
            return Consumer<DonationDriveProvider>(
              builder: (context, donationDriveProvider, child) {
                return ListView.builder(
                  itemCount: donationDriveProvider.donationDrives.length,
                  itemBuilder: (context, index) {
                    final donationDrive = donationDriveProvider.donationDrives[index];
                    return ListTile(
                      title: Text(donationDrive.title),
                      subtitle: Text(donationDrive.description),
                      onTap: () {
                        // Navigate to the donation drive detail or edit page
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DonationDriveFormPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _initiate(BuildContext context) async {
    try {
      await Firebase.initializeApp();
      await FirebaseAuth.instance.signInAnonymously();
      await Provider.of<DonationDriveProvider>(context, listen: false).fetchDonationDrives();
    } catch (e) {
      throw ('Failed to initialize Firebase: $e');
    }
  }
}
