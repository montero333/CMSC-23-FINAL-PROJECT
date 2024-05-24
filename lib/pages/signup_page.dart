import 'dart:io'; // Import dart:io for File class
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker package
import '../providers/credential_provider.dart';
import '../models/credential_model.dart';
import '../providers/auth_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isOrganization = false;
  final organizationNameController = TextEditingController();
  final proofsController = TextEditingController();
  List<String> selectedImages = []; // List to store selected image paths

  Future<void> _uploadProof() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    try {
      // Upload the selected image to Firebase Storage
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('proofs')
          .child('proof_${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(File(image.path));

      // Once uploaded, you can get the download URL of the image
      String downloadURL = await ref.getDownloadURL();

      // Update the proofsController text field with the download URL
      setState(() {
        proofsController.text = downloadURL;
        selectedImages.add(image.path); // Add selected image path to the list
      });
    } catch (e) {
      print('Error uploading proof image to Firebase Storage: $e');
    }
  } else {
    // User canceled the operation
    print('No image selected.');
  }
}


  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final addressController = TextEditingController();
    final contactNumberController = TextEditingController();

    final firstNameField = TextFormField(
      controller: firstNameController,
      enabled: !_isOrganization, // Disable if sign up as organization
      decoration: const InputDecoration(hintText: "First Name"),
      validator: (value) {
        if (!_isOrganization && (value == null || value.isEmpty)) {
          return "Please enter a first name";
        }
        return null;
      },
    );

    final lastNameField = TextFormField(
      controller: lastNameController,
      enabled: !_isOrganization, // Disable if sign up as organization
      decoration: const InputDecoration(hintText: "Last Name"),
      validator: (value) {
        if (!_isOrganization && (value == null || value.isEmpty)) {
          return "Please enter a last name";
        }
        return null;
      },
    );

    final emailField = TextFormField(
      controller: emailController,
      decoration: const InputDecoration(hintText: "Email"),
      validator: (value) {
        final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
        if (value == null || !emailRegex.hasMatch(value)) {
          return "Please enter a valid email";
        }
        return null;
      },
    );

    final passwordField = TextFormField(
      controller: passwordController,
      decoration: const InputDecoration(hintText: 'Password'),
      obscureText: true,
      validator: (value) {
        if (value == null || value.length <= 6) {
          return "Passwords must have more than 6 characters.";
        }
        return null;
      },
    );

    final addressField = TextFormField(
      controller: addressController,
      decoration: const InputDecoration(hintText: 'Address'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter an address";
        }
        return null;
      },
    );

    final contactNumberField = TextFormField(
      controller: contactNumberController,
      decoration: const InputDecoration(hintText: 'Contact Number'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a contact number";
        }
        return null;
      },
    );

    final signupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (_isOrganization && !_isOrganizationFieldsValid()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill out organization details')),
              );
              return;
            }

            final uid = await context.read<MyAuthProvider>().signUp(
              emailController.text,
              passwordController.text,
            );

            context.read<CredProvider>().addUser(
              Credential(
                userName: emailController.text,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                passWord: passwordController.text,
                address: addressController.text,
                contactNumber: contactNumberController.text,
                userRole: _isOrganization ? 'Organization' : 'Donor',
                organizationName: _isOrganization ? organizationNameController.text : null,
                proofs: _isOrganization ? proofsController.text : null,
              ),
            );

            if (context.mounted) {
              Navigator.pop(context);
            }
          }
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.blue)),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Back', style: TextStyle(color: Colors.blue)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          children: <Widget>[
            const Text(
              "Sign Up",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(child: firstNameField),
                      const SizedBox(width: 20.0),
                      Flexible(child: lastNameField),
                    ],
                  ),
                  emailField,
                  passwordField,
                  addressField,
                  contactNumberField,
                  Row(
                    children: [
                      Radio(
                        value: false,
                        groupValue: _isOrganization,
                        onChanged: (value) {
                          setState(() {
                            _isOrganization = value!;
                          });
                        },
                      ),
                      const Text('Sign up as Donor'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: true,
                        groupValue: _isOrganization,
                        onChanged: (value) {
                          setState(() {
                            _isOrganization = value!;
                          });
                        },
                      ),
                      const Text('Sign up as Organization'),
                    ],
                  ),
                  if (_isOrganization) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.grey[200],
                      child: Column(
                        children: [
                          TextFormField(
                            controller: organizationNameController,
                            decoration: const InputDecoration(hintText: 'Name of Organization'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the name of the organization";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () async {
                                    await _uploadProof(); // Call the function to upload proof
                                  },
                                  icon: Icon(Icons.camera_alt),
                                  label: Text('Upload Proof/s'),
                                ),
                              ),
                            ],
                          ),
                          // Display selected images
                          if (selectedImages.isNotEmpty) ...[
                            SizedBox(height: 10),
                            Text(
                              'Selected Images:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: selectedImages.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Colors.grey),
                                          image: DecorationImage(
                                            image: FileImage(File(selectedImages[index])),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                // Remove the image from the list
                                                _removeImage(index);
                                                // Also remove the image file from the device
                                                File(selectedImages[index]).deleteSync();
                                              },
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            signupButton,
            backButton,
          ],
        ),
      ),
    );
  }

  bool _isOrganizationFieldsValid() {
    return organizationNameController.text.isNotEmpty && proofsController.text.isNotEmpty;
  }
}
