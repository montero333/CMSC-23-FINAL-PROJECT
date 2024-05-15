import 'package:elbi_donation_system/pages/DonationsPage.dart';
import 'package:elbi_donation_system/pages/OrganizationsPage.dart';
import 'package:elbi_donation_system/providers/donors_provider.dart';
import 'package:elbi_donation_system/providers/organizations_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Flutter code sample for [NavigationBar].

void main() => runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => OrganizationsProvider())),
        ChangeNotifierProvider(create: ((context) => DonorsProvider())),
      ],
      child: MyApp(),
    ),

);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(appBarTheme: AppBarTheme(backgroundColor: Colors.black)),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Color.fromARGB(255, 186, 101, 101),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.groups),
            label: 'Organizations',
          ),
          NavigationDestination(
            icon: Icon(Icons.volunteer_activism),
            label: 'Donors',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        OrganizationsPage(),

        /// Notifications page
        DonorsPage(),
      ][currentPageIndex],
    );
  }
}