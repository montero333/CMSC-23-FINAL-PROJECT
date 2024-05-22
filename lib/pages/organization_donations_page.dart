import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/donor_model.dart';
import '../providers/donors_provider.dart';

class DonationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DonorsProvider>(
        builder: (context, donorsProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: donorsProvider.donorsList.length,
              itemBuilder: (context, index) {
                final donor = donorsProvider.donorsList[index];
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      donor.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Text(
                      'Donation: Php ${donor.donation}',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    trailing: DonationStatusDropdown(
                      donor: donor,
                      index: index,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DonationStatusDropdown extends StatelessWidget {
  final Donor donor;
  final int index;

  DonationStatusDropdown({required this.donor, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<String>(
        value: donor.status,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        underline: Container(
          height: 0,
        ),
        items: [
          'Pending',
          'Confirmed',
          'Scheduled for Pickup',
          'Complete',
          'Cancelled'
        ].map<DropdownMenuItem<String>>((String status) {
          return DropdownMenuItem<String>(
            value: status,
            child: Text(status),
          );
        }).toList(),
        onChanged: (String? newStatus) {
          if (newStatus != null) {
            Provider.of<DonorsProvider>(context, listen: false)
                .updateDonorStatus(index, newStatus);
          }
        },
      ),
    );
  }
}
