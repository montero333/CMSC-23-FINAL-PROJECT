// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../models/donation_drive_model.dart';
// import '../providers/donation_drive_provider.dart';
// import 'drive_form.dart';
// import 'edit_donation_drive.dart';

// class DonationDrivesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       // Handle case where user is not logged in
//       return Scaffold(
//         body: Center(
//           child: Text('User not logged in'),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Donation Drives'),
//       ),
//       body: StreamBuilder<List<DonationDrive>>(
//         stream: Provider.of<DonationDriveProvider>(context).donationDriveStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Text('No donation drives found.'),
//             );
//           } else {
//             final donationDrives = snapshot.data!;
//             final currentUserOrgID = currentUser.uid;

//             final orgDonationDrives = donationDrives.where((drive) => drive.orgID == currentUserOrgID).toList();

//             return ListView.builder(
//               itemCount: orgDonationDrives.length,
//               itemBuilder: (context, index) {
//                 DonationDrive donationDrive = orgDonationDrives[index];
//                 return DonationDriveCard(
//                   donationDrive: donationDrive,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => EditDonationDriveForm(donationDrive: donationDrive),
//                       ),
//                     );
//                     print('Clicked on ${donationDrive.title}');
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => CreateDonationDriveForm()),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

// class DonationDriveCard extends StatelessWidget {
//   final DonationDrive donationDrive;
//   final VoidCallback onTap;

//   DonationDriveCard({required this.donationDrive, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         margin: EdgeInsets.all(10),
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Title: ${donationDrive.title}', style: TextStyle(fontWeight: FontWeight.bold)),
//               Text('Description: ${donationDrive.description}'),
//               SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
