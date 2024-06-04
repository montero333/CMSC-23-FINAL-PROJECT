import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:montero_cmsc23/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../models/donation_drive_model.dart';
import '../providers/donation_drive_provider.dart';
import 'create_donation_drive_page.dart';
import 'donation_drive_card.dart';

class OrganizationDriveList extends StatefulWidget {
  const OrganizationDriveList({super.key});

  @override
  State<OrganizationDriveList> createState() => _OrganizationDriveListState();
}

class _OrganizationDriveListState extends State<OrganizationDriveList> {
  @override
  Widget build(BuildContext context) {
    context
        .read<DonationDriveProvider>()
        .fetchDonationDrives(context.watch<MyAuthProvider>().userID);
    Stream<QuerySnapshot> donationDrives =
        context.watch<DonationDriveProvider>().donationDrives;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateDonationDrivePage()),
            );
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('Donation Drives'),
        ),
        body: StreamBuilder(
          stream: donationDrives,
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
                child: Text("No Donation Drives Found"),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> docMap =
                    snapshot.data?.docs[index].data() as Map<String, dynamic>;
                docMap["id"] = snapshot.data?.docs[index].id;
                DonationDrive donationDrive = DonationDrive.fromJson(docMap);
                return DonationDriveCard(donationDrive: donationDrive);
              },
            );
          },
        ));
  }
}
