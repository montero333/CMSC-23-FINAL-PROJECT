import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_model.dart';
import '../providers/auth_provider.dart';
import '../providers/donation_provider.dart';

class DonationListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.watch<DonationProvider>().fetchDonationsByOrgID(context.watch<MyAuthProvider>().userID);
    Stream<QuerySnapshot> donations = context.watch<DonationProvider>().donationStream;

    return Scaffold(
      appBar: AppBar(
        title: Text("List of Donations"),
      ),
      body: StreamBuilder(
        stream: donations, 
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
                child: Text("No Donations Found"),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Donation donation = Donation.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>
                );
                return GestureDetector(
                onTap: () => {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => DonateToOrganizationDrive(donationDrive: donationDrive, userID: context.watch<MyAuthProvider>().userID),))
                },
                child: OrganizationDonationCard(donation: donation)
                );
              },
            );
        },
      ),
    );
   
  }
}

class OrganizationDonationCard extends StatefulWidget {
  final Donation donation;

  OrganizationDonationCard({required this.donation});

  @override
  _OrganizationDonationCardState createState() => _OrganizationDonationCardState();
}

class _OrganizationDonationCardState extends State<OrganizationDonationCard> {
  String _selectedStatus = '';

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.donation.status;
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _selectedStatus = newStatus;
    });
    Provider.of<DonationProvider>(context, listen: false)
        .updateDonationStatus(widget.donation.id!, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Types: ${widget.donation.getDonationTypes(widget.donation)}'),
            Text('Delivery Method: ${widget.donation.deliveryMethod}'),
            Text('Weight: ${widget.donation.weight} kg'),
            Text('Addresses: ${widget.donation.addresses.join(', ')}'),
            Text('Date: ${widget.donation.date}'),
            Text('Time: ${widget.donation.time}'),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Status: '),
                DropdownButton<String>(
                  value: _selectedStatus,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _updateStatus(newValue);
                    }
                  },
                  items: <String>[
                    'Pending',
                    'Confirmed',
                    'Scheduled for Pick-up',
                    'Complete',
                    'Canceled',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (widget.donation.image != null)
              Image.network(
                widget.donation.image!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
