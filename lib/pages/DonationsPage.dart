
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/donor_model.dart';
import '../providers/donors_provider.dart';


class DonorsPage extends StatefulWidget {
  // final List<Map> formInputsList; //form inputs list

  const DonorsPage({super.key});

  @override
  State<DonorsPage> createState() => _DonorsPageState();
}

class _DonorsPageState extends State<DonorsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const DrawerWidget(), //drawer widget
      body: Center(
        child: DonorsList(), //passes it to the FriendsList widget below
      ),
    );
  }
}

class DonorsList extends StatefulWidget {

  const DonorsList({super.key});

  @override
  State<DonorsList> createState() => _DonorsListState();
}

class _DonorsListState extends State<DonorsList> {

  @override
  Widget build(BuildContext context) {
    List<Donor> donorsList = context.watch<DonorsProvider>().donorsList;
    if (donorsList.isEmpty ) { //if list is empty
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
      itemCount: donorsList.length, //how many items in list
      itemBuilder: (context, index) {
        Donor organization = donorsList[index]; //store in variable friend
        return GestureDetector( //return a gesture detector that stores the summary for each friend and a delete button
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => OrganizationInfo(organization: organization),));
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
                    ElevatedButton(
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(4)
                      ),
                      onPressed: (){
                      setState(() {
                        donorsList.removeAt(index);
                      });
                    }, child: const Text("Delete",style: TextStyle(color: Colors.red),))
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