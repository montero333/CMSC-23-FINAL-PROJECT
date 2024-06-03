import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:montero_cmsc23/providers/auth_provider.dart';
import 'package:montero_cmsc23/providers/credential_provider.dart';
import 'package:provider/provider.dart';

class OrganizationProfilePage extends StatefulWidget {
  @override
  _OrganizationProfilePageState createState() =>
      _OrganizationProfilePageState();
}

class _OrganizationProfilePageState extends State<OrganizationProfilePage> {
  @override
  Widget build(BuildContext context) {
    String? userID = context.watch<MyAuthProvider>().userID;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Organization Profile'),
        ),
        body: FutureBuilder(
            future: context.read<CredProvider>().getUserByID(userID),
            builder: (context, snapshot) {
              return snapshot.data != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            'Name: ${snapshot.data!['firstName']} ${snapshot.data!["lastName"]}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle:
                              Text('Description: ${snapshot.data!['email']}'),
                        ),
                        // Add more ListTile widgets to display additional organization information
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }));
  }
}
