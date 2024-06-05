// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:montero_cmsc23/models/donation_drive_model.dart';
// import 'package:montero_cmsc23/providers/donation_provider.dart';
// import 'package:provider/provider.dart';
// import '../models/donation_model.dart';
// import '../providers/donation_drive_provider.dart';
// import '../api/firebase_drive_donation_api.dart';
// import '../providers/credential_provider.dart';

// class EditDonationDriveForm extends StatefulWidget {
//   final DonationDrive donationDrive;

//   EditDonationDriveForm({required this.donationDrive});

//   @override
//   _EditDonationDriveFormState createState() => _EditDonationDriveFormState();
// }

// class _EditDonationDriveFormState extends State<EditDonationDriveForm> {
//   late TextEditingController _titleController;
//   late TextEditingController _descriptionController;
//   List<String> _existingDonationIds = [];

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.donationDrive.title);
//     _descriptionController = TextEditingController(text: widget.donationDrive.description);
//     _fetchExistingDonationIds(); 
//   }

//   Future<void> _fetchExistingDonationIds() async {
//     _existingDonationIds = (await FirestoreService().getDonationIdsForDrive(widget.donationDrive.id))!;
//     setState(() {}); 
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Donation Drive'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(labelText: 'Title'),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: 'Description'),
//               maxLines: null,
//             ),
//             SizedBox(height: 16.0),
//             DonationSelectionList(
//               onDonationSelected: (donationId, isSelected) {
//                 setState(() {
//                   if (isSelected) {
//                     // Add selected donation ID
//                     _existingDonationIds.add(donationId);
//                   } else {
//                     // Remove unselected donation ID
//                     _existingDonationIds.remove(donationId);
//                   }
//                 });
//               },
//               selectedDonationIds: [], 
//               existingDonationIds: _existingDonationIds, 
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () async {
//                 final credProvider = Provider.of<CredProvider>(context, listen: false); 
//                 final orgID = await credProvider.getCurrentUserId();
//                 final updatedDonationDrive = DonationDrive(
//                   id: widget.donationDrive.id,
//                   title: _titleController.text,
//                   description: _descriptionController.text,
//                   // donationIds: _existingDonationIds,
//                   orgID: orgID!, // Use the CredProvider instance to get the current user's ID
//                 );
//                 await Provider.of<DonationDriveProvider>(context, listen: false).updateDonationDrive(updatedDonationDrive);
//                 Navigator.pop(context); 
//               },
//               child: Text('Save Changes'),
//             ),

//             ElevatedButton(
//               onPressed: () async {
//                 await _deleteDonationDrive(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//               ),
//               child: Text('Delete Donation Drive'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//     Future<void> _deleteDonationDrive(BuildContext context) async {
//     final provider = Provider.of<DonationDriveProvider>(context, listen: false);
//     await provider.removeDonationDrive(widget.donationDrive.id);
//     Navigator.pop(context); // Pop the edit page off the navigation stack
//   }
// }


// class DonationSelectionList extends StatelessWidget {
//   final Function(String, bool) onDonationSelected;
//   final List<String> selectedDonationIds;
//   final List<String> existingDonationIds;

//   DonationSelectionList({required this.onDonationSelected, required this.selectedDonationIds, required this.existingDonationIds});

//   @override
//   Widget build(BuildContext context) {
//     final donationProvider = Provider.of<DonationProvider>(context);
//     donationProvider.fetchDonationsByUserID(null); 

//     return StreamBuilder<QuerySnapshot>(
//       stream: donationProvider.donationStream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(child: Text('No donations found.'));
//         }

//         var donations = snapshot.data!.docs.map((doc) {
//           var data = doc.data() as Map<String, dynamic>;
//           data['id'] = doc.id;
//           return Donation.fromJson(data); 
//         }).toList();

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: donations.map((donation) {
//             final isSelected = selectedDonationIds.contains(donation.id!) || existingDonationIds.contains(donation.id!);
//             return CheckboxListTile(
//               title: Text('Donation ID: ${donation.id ?? 'N/A'}'),
//               subtitle: Text('Types: ${donation.getDonationTypes(donation)}'),
//               value: isSelected,
//               onChanged: (bool? value) {
//                 onDonationSelected(donation.id!, value ?? false);
//               },
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }
