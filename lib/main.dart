import 'package:elbi_donation_system/pages/admin_homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    //map of routes
    Map<String, Widget Function(BuildContext)> routes = {
        "/home" : (context) => const AdminHomePage(),
      };

    return MaterialApp(
      theme: ThemeData(appBarTheme: const AppBarTheme(color: Color.fromARGB(255, 7, 7, 8)),scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 19)),
      initialRoute: "/home",
      routes: routes,
    );
  }
}