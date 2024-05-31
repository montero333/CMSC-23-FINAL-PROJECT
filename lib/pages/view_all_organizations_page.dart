import 'package:flutter/material.dart';

class ViewAllOrganizationsPage extends StatelessWidget {
  const ViewAllOrganizationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Organizations'),
      ),
      body: const Center(
        child: Text(
          'List of all organizations will be shown here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
