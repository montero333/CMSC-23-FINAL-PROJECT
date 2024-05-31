import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizationProfilePage extends StatefulWidget {
  @override
  _OrganizationProfilePageState createState() => _OrganizationProfilePageState();
}

class _OrganizationProfilePageState extends State<OrganizationProfilePage> {
  late User? _currentUser;
  Map<String, dynamic>? _organizationData;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _fetchOrganizationData();
    }
  }

  Future<void> _fetchOrganizationData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('organizations')
          .doc(_currentUser!.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          _organizationData = snapshot.data();
        });
      }
    } catch (error) {
      print("Error fetching organization data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Profile'),
      ),
      body: _organizationData != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    'Name: ${_organizationData!['name']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Description: ${_organizationData!['description']}'),
                ),
                // Add more ListTile widgets to display additional organization information
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
