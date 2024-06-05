import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/donation_drive_model.dart';
import '../providers/donation_drive_provider.dart';
import '../providers/auth_provider.dart';

class CreateDonationDrivePage extends StatefulWidget {
  @override
  _CreateDonationDrivePageState createState() => _CreateDonationDrivePageState();
}

class _CreateDonationDrivePageState extends State<CreateDonationDrivePage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Donation Drive'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    String? userId = context.read<MyAuthProvider>().userID;
                    DonationDrive newDrive = DonationDrive(
                      title: _title,
                      description: _description,
                      orgID: userId!,
                      // Add other necessary fields here
                    );

                    await context.read<DonationDriveProvider>().addDonationDrive(newDrive);
                    Navigator.pop(context);
                  }
                },
                child: Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
