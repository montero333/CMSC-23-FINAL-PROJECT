import 'package:flutter/material.dart';

class DonorMainPage extends StatefulWidget {
  @override
  _DonorMainPageState createState() => _DonorMainPageState();
}

class _DonorMainPageState extends State<DonorMainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donor Main Page'),
      ),
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity),
            label: 'Activities',
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
        return _buildActivities();
      case 2:
        return _buildProfile();
      default:
        return Container();
    }
  }

  Widget _buildHome() {
    return Center(
      child: Text(
        'Home',
        style: TextStyle(fontSize: 24),
      ),
    );
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

