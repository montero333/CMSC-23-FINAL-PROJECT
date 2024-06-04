import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:montero_cmsc23/api/firebase_credential_api.dart';
import 'package:montero_cmsc23/pages/organization_drive_list.dart';
import 'package:montero_cmsc23/pages/organization_profile_page.dart';
import 'package:montero_cmsc23/providers/auth_provider.dart';
import 'package:montero_cmsc23/providers/credential_provider.dart';
import 'package:montero_cmsc23/providers/donation_provider.dart';
import 'package:provider/provider.dart';
import 'donation_drive_list ni gabe.dart';
import 'organization_donations_page.dart';

class OrganizationMainPage extends StatefulWidget {
  @override
  _OrganizationMainPageState createState() => _OrganizationMainPageState();
}

class _OrganizationMainPageState extends State<OrganizationMainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Organization Main Page'),
      //   actions: [ // Add actions to the app bar
      //     IconButton(
      //       icon: Icon(Icons.logout),
      //       onPressed: () {
      //         _logout(context);
      //       },
      //     ),
      //   ],
      // ),
      body: _buildBody(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.purple, // Set selected item color to purple
        unselectedItemColor: Colors.grey, // Set unselected item color to grey
        showUnselectedLabels: true, // Show labels for all items
        onTap: (index) async {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Donations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity),
            label: 'Donation Drives',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return DonationListPage();
      case 1:
        return OrganizationDriveList();
      case 2:
        return OrganizationProfilePage();
      default:
        return Container(); // Return an empty container as a default
    }
  }

  Widget _buildHomepage() {
    return Center(
      child: Text(
        'Homepage',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildDonationsPage() {
    return Center(
      child: Text(
        'Donations',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildDonationDrivesPage() {
    return Center(
      child: Text(
        'Donation Drives',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildProfilePage() {
    return Center(
      child: Text(
        'Profile',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  void _logout(BuildContext context) {
    // Implement logout functionality here
    Navigator.pushNamed(context, '/login');
  }
}
