import 'package:flutter/material.dart';
import 'package:milestone_1/pages/donor_main_page.dart';
import 'package:milestone_1/pages/organization_main_page.dart';
import 'package:provider/provider.dart';
import 'pages/admin_main_page.dart';
import 'pages/signup_page.dart';
import 'pages/login_page.dart';
import 'providers/auth_provider.dart';
import 'providers/donors_provider.dart';
import 'providers/organizations_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => OrganizationsProvider())),
        ChangeNotifierProvider(create: ((context) => DonorsProvider())),
      ],
      child: MyApp(),
    ),

  );
}

class MyApp extends StatelessWidget {
  // const MyApp(MultiProvider multiProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Flutter Auth Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isLoggedIn) {
              // Check if user is admin or regular user and navigate accordingly
              return authProvider.isAdmin ? AdminMainPage() : LoginPage();
            } else {
              return LoginPage();
            }
          },
        ),
        routes: {
          '/signup': (context) => SignUpPage(),
          '/login': (context) => LoginPage(),
          '/adminMainPage': (context) => AdminMainPage(),
          '/organizationMainPage':(context) => OrganizationMainPage(),
          '/donorMainPage': (context) => DonorMainPage(),
        },
      ),
    );
  }
}
