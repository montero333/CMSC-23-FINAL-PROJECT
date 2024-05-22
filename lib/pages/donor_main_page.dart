import 'package:flutter/material.dart';
import '/pages/donation_page_organizations.dart';

class DonorMainPage extends StatefulWidget {
  const DonorMainPage({super.key});

  @override
  _DonorMainPageState createState() => _DonorMainPageState();
}

class _DonorMainPageState extends State<DonorMainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Donations',
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
        return _buildHome();
      case 1:
        return _buildProfile();
      default:
        return Container();
    }
  }

  Widget _buildHome() {
    return DonationOrganizationsList();
  }

  Widget _buildActivities() {
    return Center(
      child: Text(
        'Activities',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildProfile() {
    return Center(
      child: Text(
        'Profile',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

