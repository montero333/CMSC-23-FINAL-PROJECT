import 'package:flutter/material.dart';

class ApprovalPage extends StatelessWidget {
  // Dummy list of organizations for demonstration
  final List<String> organizations = [
    'Organization 1',
    'Organization 2',
    'Organization 3',
    'Organization 4',
    'Organization 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: organizations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(organizations[index]), // Display organization name
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check), // Accept icon
                        onPressed: () {
                          // Handle accept action
                          print('Accepted: ${organizations[index]}');
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close), // Reject icon
                        onPressed: () {
                          // Handle reject action
                          print('Rejected: ${organizations[index]}');
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Show dialog when organization is tapped
                    _showOrganizationDialog(context, organizations[index]);
                  },
                );
              },
            ),
          ),
          // Add any other widgets below if needed
        ],
      ),
    );
  }

  // Function to show a dialog with organization details
  void _showOrganizationDialog(BuildContext context, String organizationName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Organization Details'),
          content: Text('Organization: $organizationName'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
