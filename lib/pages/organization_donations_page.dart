import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_model.dart';
import '../providers/donation_provider.dart';

class DonationListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);
    donationProvider.fetchDonationsByUserID("E2qk5ED1BgNC961QzMacveABN392"); // Replace with the appropriate user ID

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
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
            data['id'] = doc.id; // Assign the document ID to the donation ID
            return Donation.fromJson(data);
          }).toList();

          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              return DonationCard(donation: donations[index]);
            },
          );
        },
      ),
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
    // Update the status in the database
    DonationProvider().updateDonationStatus(widget.donation.id!, newStatus);
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
            // Text('Donation ID: ${widget.donation.id ?? 'N/A'}', style: TextStyle(fontWeight: FontWeight.bold)),
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
                width: double.infinity, // Adjust width as needed
                height: 200, // Adjust height as needed
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}



            // Text('Donation ID: ${widget.donation.id ?? 'N/A'}', style: TextStyle(fontWeight: FontWeight.bold)),



// class DonationStatusDropdown extends StatelessWidget {
//   final Donor donor;
//   final int index;

//   DonationStatusDropdown({required this.donor, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: DropdownButton<String>(
//         value: donor.status,
//         icon: Icon(Icons.arrow_drop_down),
//         iconSize: 24,
//         elevation: 16,
//         style: TextStyle(color: Colors.black, fontSize: 16.0),
//         underline: Container(
//           height: 0,
//         ),
//         items: [
//           'Pending',
//           'Confirmed',
//           'Scheduled for Pickup',
//           'Complete',
//           'Cancelled'
//         ].map<DropdownMenuItem<String>>((String status) {
//           return DropdownMenuItem<String>(
//             value: status,
//             child: Text(status),
//           );
//         }).toList(),
//         onChanged: (String? newStatus) {
//           if (newStatus != null) {
//             Provider.of<DonorsProvider>(context, listen: false)
//                 .updateDonorStatus(index, newStatus);
//           }
//         },
//       ),
//     );
//   }
// }
