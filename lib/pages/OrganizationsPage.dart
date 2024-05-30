import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/organization_model.dart';
import '../pages/OrganizationInfoPage.dart';
import '../providers/organizations_provider.dart';

class OrganizationsPage extends StatefulWidget {
  const OrganizationsPage({Key? key}) : super(key: key);

  @override
  State<OrganizationsPage> createState() => _OrganizationsPageState();
}

class _OrganizationsPageState extends State<OrganizationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrganizationProvider>().fetchOrganizations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Organizations"),
      ),
      body: const Center(
        child: OrganizationsList(), //passes it to the OrganizationsList widget below
      ),
    );
  }
}

class OrganizationsList extends StatelessWidget {
  const OrganizationsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final organizationsList = context.watch<OrganizationProvider>().organizations;

    if (organizationsList.isEmpty) { //if list is empty
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center, //return no organizations message
        children: [
          Text(
            "No Organizations",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          Icon(Icons.sentiment_dissatisfied_rounded, color: Colors.black),
        ],
      );
    } else {
      return ListView.builder( //return a ListView builder
        itemCount: organizationsList.length, //number of items in the list
        itemBuilder: (context, index) {
          Organization organization = organizationsList[index]; //store in variable organization
          return GestureDetector( //return a GestureDetector that stores the summary for each organization and a delete button
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrganizationInfo(organization: organization),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        organization.name,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              // padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 12)),
                              //elevation: MaterialStateProperty.all(4)
                            ),
                            onPressed: () {
                              // Add your "like" functionality here
                            },
                            child: const Icon(Icons.thumb_up, color: Colors.green),
                          ),
                          const SizedBox(width: 5),
                          ElevatedButton(
                            style: ButtonStyle(
                              //padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 12)),
                              //elevation: MaterialStateProperty.all(4)
                            ),
                            onPressed: () {
                              context.read<OrganizationProvider>().deleteOrganization(organization.id);
                            },
                            child: const Icon(Icons.thumb_down, color: Colors.red),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
