import 'package:flutter/material.dart';
import 'package:montero_cmsc23/api/firebase_donations_api.dart';
import 'package:montero_cmsc23/models/donation_model.dart';
import 'package:montero_cmsc23/pages/organization_donations_page.dart';
import 'package:montero_cmsc23/providers/auth_provider.dart';
import 'package:provider/provider.dart';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      donationDrive.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    SizedBox(
                        width: MediaQuery.sizeOf(context).width - 100,
                        child: Text(donationDrive.description)),
                  ],
                ),
                Icon(Icons.add)
              ],
            ),
            StreamBuilder(
                stream: FirebaseDonationsAPI()
                    .getAllDonationsByDriveID(donationDrive.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error encountered! ${snapshot.error}"),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No Donations Found"),
                    );
                  }

                  return SizedBox(
                    height: 250,
                    child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> docMap = snapshot.data?.docs[index]
                            .data() as Map<String, dynamic>;
                        docMap["id"] = snapshot.data?.docs[index].id;
                        Donation donation = Donation.fromJson(docMap);
                        return GestureDetector(
                            onTap: () => {
                                  print(donation.id)
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => DonateToOrganizationDrive(donationDrive: donationDrive, userID: context.watch<MyAuthProvider>().userID),))
                                },
                            child:
                                OrganizationDonationCard(donation: donation));
                      },
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
