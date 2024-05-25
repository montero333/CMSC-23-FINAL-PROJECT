import 'package:flutter/material.dart';
import 'package:montero_cmsc23/pages/donor_main_page.dart';
import 'package:montero_cmsc23/pages/signup_page.dart';
import 'package:provider/provider.dart';
import '../providers/credential_provider.dart';
import '../providers/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => CredProvider())),
        ChangeNotifierProvider(create: ((context) => MyAuthProvider())),
      ],
      child: const MyApp(),
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
        '/donor':(context) => const DonorMainPage()
      },
    );
  }
}
