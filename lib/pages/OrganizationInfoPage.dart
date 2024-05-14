import 'package:flutter/material.dart';

import '../models/organization_model.dart';

class OrganizationInfo extends StatelessWidget {
  final Organization organization;

  const OrganizationInfo({super.key, required this.organization});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Summary",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
      children: [
        //text for displaying the summary title
        const Text(
            "SUMMARY",
            style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold)
          ),
        //row for organizing the summary details
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //sized box for providing spacing
          children: [const SizedBox(width: 25),
            //column for displaying labels
            const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
                "Organization Name:",
                style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold)
              ),
              Text(
                "Donations:",
                style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold)
              )
          ],
          ),
          //sized box for providing spacing
          const SizedBox(width: 25), 
          //expanded column for displaying dynamic user input details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  organization.name,
                  style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontStyle: FontStyle.italic)
                ),
                Text(
                  "${organization.donation}",
                  style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontStyle: FontStyle.italic)
                ),
              ],
            ),
          )
          ],
        ),
      ],
    )
      ); 
  }
}