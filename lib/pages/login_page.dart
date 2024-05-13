import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login Page',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text(
                'No account yet? Click here to register',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) {
  String username = _usernameController.text.trim();
  String password = _passwordController.text.trim();

  if (username.isNotEmpty && password.isNotEmpty) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.checkCredentials(username, password)) {
      // Navigate to admin main page if username and password are "admin"
      if (username == "admin" && password == "admin") {
        Navigator.pushReplacementNamed(context, '/adminMainPage');
      } else if (username == "organization" && password == "organization") {
        // Navigate to organization main page if username and password are "organization"
        Navigator.pushReplacementNamed(context, '/organizationMainPage');
      } else {
        // Show success message using a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login successful'),
          duration: Duration(seconds: 2),
        ));
        Navigator.pushNamed(context, '/donorMainPage');
        // Navigate to home page or perform any other action
      }
    } else {
      // Show error message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login failed: Invalid username or password'),
        duration: Duration(seconds: 2),
      ));
    }
  } else {
    // Show validation error message using a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Please fill in all fields'),
      duration: Duration(seconds: 2),
    ));
  }
}




}
