import 'dart:io';
import 'package:flutter/material.dart';
import 'package:montero_cmsc23/api/firebase_credential_api.dart';
import 'package:montero_cmsc23/pages/login.dart';
import 'package:provider/provider.dart';
import '../providers/credential_provider.dart';
import '../models/credential_model.dart';
import '../providers/auth_provider.dart';

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

  final FirebaseCredAPI _firebaseCredAPI = FirebaseCredAPI(); // Initialize FirebaseCredAPI

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final contactNumberController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addressController.dispose();
    contactNumberController.dispose();
    organizationNameController.dispose();
    proofsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

            bool emailExists = await _firebaseCredAPI.checkIfEmailExistsInDatabase(emailController.text);
            if (emailExists) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email already exists')),
              );
              return;
            }

            if (_isOrganization) {
              bool orgNameExists  = await _firebaseCredAPI.checkIfOrganizationNameExists(organizationNameController.text);
              if (orgNameExists ) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Organization name already exists')),
                );
                return;
              }
            }

            final uid = await context.read<MyAuthProvider>().signUp(
              emailController.text,
              firstNameController.text,
              lastNameController.text,
              passwordController.text,
              addressController.text,
              contactNumberController.text,
              _isOrganization ? 'Organization' : 'Donor',
            );

            context.read<CredProvider>().addUser(
              Credential(
                userId: uid,
                email: emailController.text,
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

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        },
        child: const Text('Sign Up'),
      ),
    );

    final backButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Back to login'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  firstNameField,
                  lastNameField,
                  emailField,
                  passwordField,
                  addressField,
                  contactNumberField,
                  const SizedBox(height: 20),
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
                                    await _firebaseCredAPI.uploadProof(
                                      proofsController: proofsController,
                                      selectedImages: selectedImages,
                                      setStateCallback: setState,
                                    );
                                  },
                                  icon: const Icon(Icons.camera_alt),
                                  label: const Text('Upload Proof/s'),
                                ),
                              ),
                            ],
                          ),
                          // Display selected images
                          if (selectedImages.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            const Text(
                              'Selected Images:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: selectedImages.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 10),
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
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                _firebaseCredAPI.removeImage(
                                                  index: index,
                                                  selectedImages: selectedImages,
                                                  setStateCallback: setState,
                                                );
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
