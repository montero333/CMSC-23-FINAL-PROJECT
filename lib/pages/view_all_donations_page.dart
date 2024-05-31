import 'package:flutter/material.dart';
import 'package:montero_cmsc23/models/donation_model.dart';

class ViewAllDonationsPage extends StatelessWidget {
  ViewAllDonationsPage({super.key});

  // Mock list of donations
  final List<Donation> donations = [
    Donation(
      id: '1',
      driveID: 'drive1',
      userID: 'user1',
      food: true,
      clothes: false,
      cash: false,
      necessities: true,
      others: false,
      deliveryMethod: 'Pickup',
      weight: 10.5,
      addresses: ['Address 1', 'Address 2'],
      date: '2024-06-01',
      time: '10:00 AM',
      status: 'Pending',
    ),
    Donation(
      id: '2',
      driveID: 'drive2',
      userID: 'user2',
      food: false,
      clothes: true,
      cash: false,
      necessities: false,
      others: false,
      deliveryMethod: 'Drop-off',
      weight: 5.2,
      addresses: ['Address 3'],
      date: '2024-06-02',
      time: '02:00 PM',
      status: 'Delivered',
    ),
    Donation(
      id: '3',
      driveID: 'drive3',
      userID: 'user3',
      food: true,
      clothes: true,
      cash: false,
      necessities: false,
      others: true,
      deliveryMethod: 'Pickup',
      weight: 8.0,
      addresses: ['Address 4', 'Address 5'],
      date: '2024-06-03',
      time: '05:00 PM',
      status: 'Approved',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Donations'),
      ),
      body: ListView.builder(
        itemCount: donations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Donation ID: ${donations[index].id}'),
            subtitle: Text('Date: ${donations[index].date}, Time: ${donations[index].time}'),
            onTap: () {
              // Navigate to a donation details page or show details in a dialog
              showDonationDetails(context, donations[index]);
            },
          );
        },
      ),
    );
  }

  void showDonationDetails(BuildContext context, Donation donation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Donation Details - ID: ${donation.id}'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Delivery Method: ${donation.deliveryMethod}'),
              Text('Weight: ${donation.weight} kg'),
              Text('Addresses: ${donation.addresses.join(', ')}'),
              Text('Date: ${donation.date}'),
              Text('Time: ${donation.time}'),
              Text('Status: ${donation.status}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
