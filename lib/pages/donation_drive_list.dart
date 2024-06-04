import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../providers/donation_drive_provider.dart';
import '../pages/donateTo_OrganizationPage.dart';
import 'package:provider/provider.dart';
import '../models/donation_drive_model.dart';
import '../models/organization_model.dart';
import '../providers/auth_provider.dart';
import '../providers/organizations_provider.dart';
import 'OrganizationInfoPage.dart';
import 'donation_drive_card.dart';

class DonationDriveList extends StatefulWidget {
  // final List<DonationDrive> donationDrives;
  final String? organizationUserID;

  const DonationDriveList({super.key, required this.organizationUserID});

  _DonationDriveListState createState() => _DonationDriveListState();
}

class _DonationDriveListState extends State<DonationDriveList> {
  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.organizationUserID != null) {
  //     print(widget.organizationUserID);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    context
        .read<DonationDriveProvider>()
        .fetchDonationDrives(widget.organizationUserID);
    Stream<QuerySnapshot> donationDrives =
        context.watch<DonationDriveProvider>().donationDrives;
    return Scaffold(
        appBar: AppBar(
          title: Text("List of Donation Drives"),
          backgroundColor: Colors.green,
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

            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> docMap =
                      snapshot.data?.docs[index].data() as Map<String, dynamic>;
                  docMap["id"] = snapshot.data?.docs[index].id;
                  DonationDrive donationDrive = DonationDrive.fromJson(docMap);
                  ;
                  return GestureDetector(
                      onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DonateToOrganizationDrive(
                                          donationDrive: donationDrive,
                                          userID: context
                                              .watch<MyAuthProvider>()
                                              .userID),
                                ))
                          },
                      child: DonationDriveCard(donationDrive: donationDrive));
                },
              ),
            );
          },
        ));
  }
}
