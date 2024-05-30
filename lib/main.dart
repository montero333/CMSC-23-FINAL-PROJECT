import 'package:flutter/material.dart';
import 'package:montero_cmsc23/pages/admin_view_donors.dart';
import '../pages/donor_main_page.dart';
import 'package:montero_cmsc23/pages/signup_page.dart';
import '../pages/organization_main_page.dart';
import '../providers/donation_provider.dart';
import 'package:provider/provider.dart';
import 'pages/admin_main_page.dart';
import 'pages/login_page.dart';
import '../providers/credential_provider.dart';
import '../providers/auth_provider.dart';
import 'providers/donors_provider.dart';
import 'providers/organizations_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/donation_drive_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => OrganizationProvider())),
        ChangeNotifierProvider(create: ((context) => DonorsProvider())),
        ChangeNotifierProvider(create: ((context) => DonationProvider())),
        ChangeNotifierProvider(create: ((context) => CredProvider())),
        ChangeNotifierProvider(create: ((context) => MyAuthProvider())),
        ChangeNotifierProvider(create: ((context) => DonationDriveProvider())),

      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root widget of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication',
      initialRoute: '/login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/donor':(context) => const DonorMainPage(),
        '/organization':(context) =>  OrganizationMainPage(),
        '/admin-view-donors': (context) => AdminViewDonors()
      },
    );
  }
}
