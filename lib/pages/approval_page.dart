import 'package:flutter/material.dart';

class ApprovalPage extends StatefulWidget {
  @override
  _ApprovalPageState createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  // Dummy list of organizations for demonstration
  List<String> organizations = [
    'Organization 1',
    'Organization 2',
    'Organization 3',
    'Organization 4',
    'Organization 5',
  ];

  // Function to add organization when accepted
  void _acceptOrganization(String organizationName) {
    // Add organization to your organization provider here
    // For demonstration, I'm just printing the accepted organization
    print('Accepted: $organizationName');
    // Assuming your organization provider has a method to add organizations
    // organizationProvider.addOrganization(organizationName);

    // You can remove the accepted organization from the list
    setState(() {
      organizations.remove(organizationName);
    });
  }

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
                          _acceptOrganization(organizations[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close), // Reject icon
                        onPressed: () {
                          // Handle reject action
                          print('Rejected: ${organizations[index]}');
                          // You can handle rejection if needed
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
