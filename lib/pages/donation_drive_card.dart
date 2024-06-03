import 'package:flutter/material.dart';
import '../models/donation_drive_model.dart';

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