// lib/pages/donation_drive_form_page.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/donation_drive_model.dart';
import '../providers/donation_drive_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DonationDriveFormPage extends StatefulWidget {
  @override
  _DonationDriveFormPageState createState() => _DonationDriveFormPageState();
}

class _DonationDriveFormPageState extends State<DonationDriveFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance.ref().child('donation_drives/${DateTime.now().toIso8601String()}');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      }

      final newDonationDrive = DonationDrive(
        id: DateTime.now().toIso8601String(),
        title: _title,
        description: _description,
        startDate: _startDate,
        endDate: _endDate,
        imageUrl: imageUrl,
      );

      Provider.of<DonationDriveProvider>(context, listen: false).addDonationDrive(newDonationDrive);
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
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
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: _startDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                      }
                    });
                  },
                  child: Text('Select Start Date'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                      }
                    });
                  },
                  child: Text('Select End Date'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Select Image'),
                ),
                _imageFile == null
                    ? Text('No image selected.')
                    : Image.file(_imageFile!),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
