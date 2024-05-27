import 'package:flutter/material.dart';

class DonorMainPage extends StatelessWidget {
  const DonorMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the Donor Dashboard!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Define the action for this button
              },
              child: const Text('Make a Donation'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Define the action for this button
              },
              child: const Text('View Donation History'),
            ),
          ],
        ),
      ),
    );
  }
}
