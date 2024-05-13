import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address/es'),
            ),
            TextField(
              controller: _contactNoController,
              decoration: InputDecoration(labelText: 'Contact No.'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _signUp(context);
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  void _signUp(BuildContext context) {
  String name = _nameController.text.trim();
  String username = _usernameController.text.trim();
  String password = _passwordController.text.trim();
  List<String> addresses = _addressController.text.split(',').map((e) => e.trim()).toList();
  String contactNo = _contactNoController.text.trim();

  if (name.isNotEmpty && username.isNotEmpty && password.isNotEmpty && addresses.isNotEmpty && contactNo.isNotEmpty) {
    Provider.of<AuthProvider>(context, listen: false).signUp(name, username, password, addresses, contactNo)
        .then((success) {
      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sign up successful!'),
          duration: Duration(seconds: 2),
        ));
        // Clear text fields after successful sign-up
        _nameController.clear();
        _usernameController.clear();
        _passwordController.clear();
        _addressController.clear();
        _contactNoController.clear();
        // Navigate back to the login page
        Navigator.pop(context);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sign up failed. Please try again.'),
          duration: Duration(seconds: 2),
        ));
      }
    });
  } else {
    // Show validation error message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Please fill in all fields.'),
      duration: Duration(seconds: 2),
    ));
  }
}

}
