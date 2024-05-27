import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:montero_cmsc23/pages/drawer.dart';
import 'package:montero_cmsc23/providers/credential_provider.dart';
import 'package:montero_cmsc23/providers/donation_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/donation_model.dart';
import '../providers/auth_provider.dart';
import 'edit_profile_page.dart';

class DonorProfilePage extends StatefulWidget {
  @override
  _DonorProfilePageState createState() => _DonorProfilePageState();
}

class _DonorProfilePageState extends State<DonorProfilePage> {
  File? _image;
  final List<Map<String, dynamic>> _donations = [
    // Sample donations, you can replace this with your data source
    {
      'date': '2023-01-01',
      'items': 'Clothes, Food',
      'status': 'Delivered',
    },
    {
      'date': '2023-02-15',
      'items': 'Cash',
      'status': 'Pending',
    },
  ];

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  
  

  @override
  Widget build(BuildContext context) {
    String? userID = context.watch<MyAuthProvider>().userID;
    context.watch<DonationProvider>().fetchDonationsByUserID(userID);
    Stream<QuerySnapshot> donationStream = context.watch<DonationProvider>().donationStream;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Donor Profile'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()))
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.black,
                        )
                      : null,
                ),
                SizedBox(width: 15,),
                FutureBuilder<Map<String, dynamic>?>(
                  future: context.read<CredProvider>().getUserByID(userID),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Text("User not found");
                    } else {
                      Map<String, dynamic>? userData = snapshot.data;
                      return Text("${userData!['firstName']} ${userData['lastName']}");
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'My Donations',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder(
                stream: donationStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error encountered! ${snapshot.error}"),
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: Text("No Todos Found"),
                    );
                  }

                  
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      Donation donation = Donation.fromJson(snapshot.data?.docs[index].data() as Map<String, dynamic>);
                      return Card(
                        child: ListTile(
                          title: Text("Type: ${donation.getDonationTypes(donation)}"),
                          subtitle: Text('Date: ${donation.date}'),
                          trailing: Text(donation.status),
                        ),
                      );
                    },
                  );
                })
              ),
            ),
          ],
        ),
      ),
    );
  }
}
