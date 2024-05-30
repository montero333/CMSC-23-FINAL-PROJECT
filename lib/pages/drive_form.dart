import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/donation_drive_model.dart';
import '../providers/donation_drive_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DonationDriveFormPage extends StatefulWidget {
  @override
  _DonationDriveFormPageState createState() => _DonationDriveFormPageState();
}

class _DonationDriveFormPageState extends State<DonationDriveFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  List<File> _images = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      if (pickedFiles != null) {
        _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final newDrive = DonationDrive(
        id: DateTime.now().toString(),
        title: _title,
        description: _description,
        imageUrls: _images.map((image) => image.path).toList(),
      );

      // Add the new donation drive to Firestore
      await Provider.of<DonationDriveProvider>(context, listen: false).addDonationDrive(newDrive, _images as List<File>);

      // Navigate back to the previous page
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Donation Drive'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              SizedBox(height: 20),
              _images.isEmpty
                  ? Text('No images selected.')
                  : Column(
                      children: _images.map((image) => Image.file(image, height: 200)).toList(),
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Pick Images'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
