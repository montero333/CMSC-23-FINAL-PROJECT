import 'package:flutter/material.dart';
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
            icon: Icon(Icons.home),
            label: 'Homepage',
          ),
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
        return _buildHomepage();
      case 1:
        return DonationsPage();
      case 2:
        return _buildDonationDrivesPage();
      case 3:
        return _buildProfilePage();
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
