//friendspage dart
import '../pages/OrganizationInfoPage.dart';
import '../providers/organizations_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/organization_model.dart';


class OrganizationsPage extends StatefulWidget {
  // final List<Map> formInputsList; //form inputs list

  const OrganizationsPage({super.key});

  @override
  State<OrganizationsPage> createState() => _OrganizationsPageState();
}

class _OrganizationsPageState extends State<OrganizationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const DrawerWidget(), //drawer widget
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
          title: const Text(
            "Organizations",
            style: TextStyle(color: Colors.white),
          ),
        ),
      body: Center(
        child: OrganizationsList(), //passes it to the FriendsList widget below
      ),
    );
  }
}

class OrganizationsList extends StatefulWidget {

  const OrganizationsList({super.key});

  @override
  State<OrganizationsList> createState() => _OrganizationsListState();
}

class _OrganizationsListState extends State<OrganizationsList> {

  @override
  Widget build(BuildContext context) {
    List<Organization> organizationsList = context.watch<OrganizationsProvider>().organizationsList;
    if (organizationsList.isEmpty ) { //if list is empty
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center, //return no friends message
        children: [
          Text(
            "No friends ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          Icon(Icons.sentiment_dissatisfied_rounded ,color: Colors.white,),
        ],
      );
    } else {
      return ListView.builder( //return a listview builder
      itemCount: organizationsList.length, //how many items in list
      itemBuilder: (context, index) {
        Organization organization = organizationsList[index]; //store in variable friend
        return GestureDetector( //return a gesture detector that stores the summary for each friend and a delete button
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrganizationInfo(organization: organization),));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Card(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(organization.name,
                    style: const TextStyle(
                      fontSize: 24,
                    ),),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 12)),
                            elevation: MaterialStatePropertyAll(4)
                          ),
                          onPressed: (){
                        }, child: const Icon(Icons.thumb_up,color: Colors.green,)),
                        SizedBox(width: 5),
                        ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 12)),
                            elevation: MaterialStatePropertyAll(4)
                          ),
                          onPressed: (){
                          setState(() {
                            organizationsList.removeAt(index);
                          });
                        }, child: const Icon(Icons.thumb_down,color: Colors.red,)),
                      ],
                    )
                  ],
                ),
              ),),
          ),
        );
        },
      );
    }

    
  }
}