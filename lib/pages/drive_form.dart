import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:montero_cmsc23/models/image_constants.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_model.dart';
import '../models/donation_drive_model.dart';
import '../providers/donation_drive_provider.dart';
import '../providers/donation_provider.dart';
import '../providers/credential_provider.dart';

class CreateDonationDriveForm extends StatefulWidget {
  @override
  _CreateDonationDriveFormState createState() => _CreateDonationDriveFormState();
}

class _CreateDonationDriveFormState extends State<CreateDonationDriveForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? imageUrl;
  List<String> _selectedDonationIds = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDonationIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select at least one donation')),
        );
        return;
      }

      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please pick an image')),
        );
        return;
      }

      final donationDriveProvider = Provider.of<DonationDriveProvider>(context, listen: false);
      final credProvider = Provider.of<CredProvider>(context, listen: false);

      // Get the current user's ID
      final orgID = await credProvider.getCurrentUserId();
      // late User? _currentUser = FirebaseAuth.instance.currentUser;
      final donationDrive = DonationDrive(
        id: FirebaseFirestore.instance.collection('donation_drives').doc().id,
        title: _titleController.text,
        description: _descriptionController.text,
        donationIds: _selectedDonationIds,
        proofPhotoUrl: ImageConstants().convertToBase64(imageUrl),
        orgID: orgID!,
      );

      try {
        // Add donation drive to Firestore and update provider
        await donationDriveProvider.addDonationDrive(donationDrive);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Donation drive created successfully!')),
        );

        // Navigate back to the original screen
        Navigator.pop(context);
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create donation drive: $e')),
        );
      }
    }
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        imageUrl = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

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
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Select Donations'),
              ElevatedButton(
                onPressed: () async {
                  final selectedDonationIds = await Navigator.push<List<String>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DonationSelectionList(),
                    ),
                  );

                  if (selectedDonationIds != null) {
                    setState(() {
                      _selectedDonationIds = selectedDonationIds;
                    });
                  }
                },
                child: Text('Select Donations'),
              ),
              SizedBox(height: 20),
              if (_selectedDonationIds.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected Donations:'),
                    ..._selectedDonationIds.map((id) => Text('Donation ID: $id')).toList(),
                  ],
                ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.photo_library),
                onPressed: () => pickImage(ImageSource.gallery),
                label: Text("Pick from Gallery"),
              ),
              if (imageUrl != null) // Show image preview if available
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Image you picked:"),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Image.file(imageUrl!, width: 200, height: 200),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        setState(() {
                          imageUrl = null;
                        })
                      },
                      child: Text("Remove Image"),
                    )
                  ],
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

class DonationSelectionList extends StatefulWidget {
  @override
  _DonationSelectionListState createState() => _DonationSelectionListState();
}

class _DonationSelectionListState extends State<DonationSelectionList> {
  List<String> _tempSelectedDonationIds = [];

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);
    donationProvider.fetchDonationsByUserID(null); // Fetch all donations for now

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Donations for Drive'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: donationProvider.donationStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No donations found.'));
          }

          var donations = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id; // Assign the document ID to the donation ID
            return Donation.fromJson(data); // Assuming Donation has a fromJson constructor
          }).toList();

          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              return DonationSelectionTile(
                donation: donations[index],
                onDonationSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      _tempSelectedDonationIds.add(donations[index].id!);
                    } else {
                      _tempSelectedDonationIds.remove(donations[index].id!);
                    }
                  });
                },
                isSelected: _tempSelectedDonationIds.contains(donations[index].id!),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _tempSelectedDonationIds);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

class DonationSelectionTile extends StatefulWidget {
  final Donation donation;
  final Function(bool) onDonationSelected;
  final bool isSelected;

  DonationSelectionTile({required this.donation, required this.onDonationSelected, required this.isSelected});

  @override
  _DonationSelectionTileState createState() => _DonationSelectionTileState();
}

class _DonationSelectionTileState extends State<DonationSelectionTile> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text('Donation ID: ${widget.donation.id ?? 'N/A'}'),
      subtitle: Text('Types: ${widget.donation.getDonationTypes(widget.donation)}'),
      value: _isSelected,
      onChanged: (bool? value) {
        setState(() {
          _isSelected = value ?? false;
          widget.onDonationSelected(_isSelected);
        });
      },
    );
  }
}
