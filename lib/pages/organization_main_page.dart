import 'package:flutter/material.dart';
import 'package:milestone_1/pages/DonationsPage.dart';
import 'package:milestone_1/pages/OrganizationsPage.dart';
import 'package:provider/provider.dart';
import '../models/organization_model.dart';
import 'organization_donations_page.dart';
import 'OrganizationInfoPage.dart';
import '../providers/organizations_provider.dart';
import '../pages/donation_drive.dart';

class OrganizationMainPage extends StatefulWidget {
  List<Organization> organizationsList = [];
  @override
  _OrganizationMainPageState createState() => _OrganizationMainPageState();
}

class _OrganizationMainPageState extends State<OrganizationMainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
 widget.organizationsList = context.watch<OrganizationsProvider>().organizationsList;
    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Main Page'),
        actions: [ // Add actions to the app bar
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: _buildBody(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.purple, // Set selected item color to purple
        unselectedItemColor: Colors.grey, // Set unselected item color to grey
        showUnselectedLabels: true, // Show labels for all items
        onTap: (index) {
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
        return DonationsPage();
      case 1:
        return ManageDonationDrivesScreen();
      case 2:
        return OrganizationInfo(organization: widget.organizationsList[0]);
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
