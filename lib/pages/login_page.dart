import 'package:flutter/material.dart';
import 'package:montero_cmsc23/providers/credential_provider.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Add regex validation for email format if needed
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // Add additional password validation if needed
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      key: const Key('emailField'),
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
      validator: validateEmail,
    );

    final password = TextFormField(
      key: const Key('passwordField'),
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      validator: validatePassword,
    );

    final loginButton = Padding(
      key: const Key('loginButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // Validation passed, proceed with login
            String email = emailController.text.trim();
            String password = passwordController.text.trim();
            bool success = await context.read<MyAuthProvider>().signIn(email, password);
            if (success) {
              // Retrieve user role
              String? role = await context.read<CredProvider>().getUserRoleByEmail(email);
              if (role != null) {
                print("User role: $role");
                // Check if the user is approved
                if (role == 'Organization') {
                  bool isApproved = await context.read<CredProvider>().isOrganizationApproved(email);
                  if (!isApproved) {
                    // Show Snackbar error if the organization is not approved
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Your organization is not yet approved.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    return;
                  }
                }
                // Navigate based on user role
                if (role == 'Donor') {
                  Navigator.pushNamed(context, '/donor');
                } else if (role == 'Organization') {
                  Navigator.pushNamed(context, '/organization');
                } else if (role == 'Admin') {
                  Navigator.pushNamed(context, '/admin-main');
                }
              } else {
                print("Failed to retrieve user role.");
              }
            } else {
              // Show Snackbar error for login failure
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Incorrect email or password.'),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          }
        },
        child: const Text('Log In', style: TextStyle(color: Colors.blue)),
      ),
    );

    final signUpButton = Padding(
      key: const Key('signUpButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SignupPage(),
            ),
          );
        },
        child: const Text('Sign Up', style: TextStyle(color: Colors.blue)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            children: <Widget>[
              const Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              email,
              password,
              loginButton,
              signUpButton,
            ],
          ),
        ),
      ),
    );
  }
}
