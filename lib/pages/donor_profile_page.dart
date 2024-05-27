import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'edit_profile_page.dart';

class DonorProfilePage extends StatefulWidget {
  @override
  _DonorProfilePageState createState() => _DonorProfilePageState();
}

class _DonorProfilePageState extends State<DonorProfilePage> {
  File? _image;
  final List<Map<String, dynamic>> _donations = [
    // Sample donations, you can replace this with your data source
    {
      'date': '2023-01-01',
      'items': 'Clothes, Food',
      'status': 'Delivered',
    },
    {
      'date': '2023-02-15',
      'items': 'Cash',
      'status': 'Pending',
    },
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donor Profile'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()))
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.black,
                        )
                      : null,
                ),
                SizedBox(width: 15,),
                Text("Fname Lname")
              ],
            ),
            SizedBox(height: 16),
            Text(
              'My Donations',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _donations.length,
                itemBuilder: (context, index) {
                  final donation = _donations[index];
                  return Card(
                    child: ListTile(
                      title: Text(donation['items']),
                      subtitle: Text('Date: ${donation['date']}'),
                      trailing: Text(donation['status']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
