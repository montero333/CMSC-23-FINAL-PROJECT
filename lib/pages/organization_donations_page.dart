import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_model.dart';
import '../providers/donation_provider.dart';

class DonationListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Text('User not logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Donation List"),
      ),
      body: DonationList(userID: currentUser.uid),
    );
  }
}

class DonationList extends StatelessWidget {
  final String userID;

  DonationList({required this.userID});

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);
    donationProvider.fetchDonationsByUserID(userID);

    return StreamBuilder<QuerySnapshot>(
      stream: donationProvider.donationStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No donations found.'));
        }

        var donations = snapshot.data!.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return Donation.fromJson(data);
        }).toList();

        return ListView.builder(
          itemCount: donations.length,
          itemBuilder: (context, index) {
            return DonationCard(donation: donations[index]);
          },
        );
      },
    );
  }
}
class DonationCard extends StatefulWidget {
  final Donation donation;

  DonationCard({required this.donation});

  @override
  _DonationCardState createState() => _DonationCardState();
}

class _DonationCardState extends State<DonationCard> {
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
