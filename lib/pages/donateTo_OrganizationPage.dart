import 'package:flutter/material.dart';
import 'package:milestone_1/pages/OrganizationInfoPage.dart';
import '../models/organization_model.dart';

class DonateToOrganization extends StatefulWidget {
  final Organization organization;
  const DonateToOrganization({super.key,required this.organization});

  @override
  State<DonateToOrganization> createState() => _DonateToOrganizationState();
}

class _DonateToOrganizationState extends State<DonateToOrganization> {
  Map<String, dynamic> donationFormInput= {"food":false, "clothes": false, "cash": false, "necessities": false, "others": false,"dropoff_or_pickup":""};
  List<String> pickUp_or_dropOff = ["pickUp","dropOff"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donate to ${widget.organization.name}"),
      ),
      body: Column(
        children: [
          Text("Donation Type",style: TextStyle(color: Colors.black),),
          CheckboxListTile(
            title: const Text('Food'),
            value: donationFormInput["food"],
            controlAffinity: ListTileControlAffinity.leading,
            onChanged:(bool? value) {
              setState(() {
                donationFormInput["food"] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Clothes'),
            value: donationFormInput["clothes"],
            controlAffinity: ListTileControlAffinity.leading,
            onChanged:(bool? value) {
              setState(() {
                donationFormInput["clothes"] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Cash'),
            value: donationFormInput["cash"],
            controlAffinity: ListTileControlAffinity.leading,
            onChanged:(bool? value) {
              setState(() {
                donationFormInput["cash"] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Necessities'),
            value: donationFormInput["necessities"],
            controlAffinity: ListTileControlAffinity.leading,
            onChanged:(bool? value) {
              setState(() {
                donationFormInput["necessities"] = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Others'),
            value: donationFormInput["others"],
            controlAffinity: ListTileControlAffinity.leading,
            onChanged:(bool? value) {
              setState(() {
                donationFormInput["others"] = value!;
              });
            },
          ),
          Text("Pick up or Drop Off?",style: TextStyle(color: Colors.black),),
          RadioListTile<String>(
            title: const Text('Pick Up'),
            value: pickUp_or_dropOff[0],
            groupValue: donationFormInput["dropoff_or_pickup"],
            onChanged: (String? value) {
              setState(() {
                donationFormInput["dropoff_or_pickup"] = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Drop Off'),
            value: pickUp_or_dropOff[1],
            groupValue: donationFormInput["dropoff_or_pickup"],
            onChanged: (String? value) {
              setState(() {
                donationFormInput["dropoff_or_pickup"] = value;
              });
            },
          ),
          ElevatedButton(onPressed: () => {
            print(donationFormInput)
          }, child: Text("Next"))
        ],
      ),
    );
  }
}