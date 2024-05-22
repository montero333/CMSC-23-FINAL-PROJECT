import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/credential_provider.dart';
import '../models/credential_model.dart';
import '../providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

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
      decoration: const InputDecoration(hintText: "First Name"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a first name";
        }
        return null;
      },
    );

    final lastNameField = TextFormField(
      controller: lastNameController,
      decoration: const InputDecoration(hintText: "Last Name"),
      validator: (value) {
        if (value == null || value.isEmpty) {
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
                    userRole: 'Donors', // Or any other role if needed
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
}
