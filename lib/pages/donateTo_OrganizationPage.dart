import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/donation_drive_model.dart';
import 'package:intl/intl.dart'; // Import the intl package


class DonateToOrganizationDrive extends StatefulWidget {
  final DonationDrive donationDrive;
  const DonateToOrganizationDrive({super.key, required this.donationDrive});

  @override
  State<DonateToOrganizationDrive> createState() => _DonateToOrganizationDriveState();
}

class _DonateToOrganizationDriveState extends State<DonateToOrganizationDrive> {
  Map<String, dynamic> donationFormInput = {
    "food": false,
    "clothes": false,
    "cash": false,
    "necessities": false,
    "others": false,
    "dropoff_or_pickup": "pickUp",
    "weight": 0,
    "addresses": [],
    "date": null,
  };
  List<String> pickUp_or_dropOff = ["pickUp", "dropOff"];
  File? image;
  final addressController = TextEditingController();
  final weightController = TextEditingController();

  void updateWeight(String weightValue) {
    try {
      double weight = double.parse(weightValue);
      setState(() {
        donationFormInput["weight"] = weight;
      });
    } on FormatException catch (e) {
      print("Invalid weight input: $e");
    }
  }

  void addAddress() {
    String newAddress = addressController.text;
    if (newAddress.isNotEmpty) {
      setState(() {
        donationFormInput["addresses"].add(newAddress);
        addressController.clear();
      });
    }
  }

  void removeAddress(int index) {
    setState(() {
      donationFormInput["addresses"].removeAt(index);
    });
  }

  bool isFormValid() {
    bool isCheckboxChecked = donationFormInput["food"] ||
        donationFormInput["clothes"] ||
        donationFormInput["cash"] ||
        donationFormInput["necessities"] ||
        donationFormInput["others"];
    bool isDateSelected = donationFormInput["date"] != null;
    bool isWeightValid = donationFormInput["weight"] > 0;
    bool isAddressEntered = donationFormInput["addresses"].isNotEmpty;

    if ( donationFormInput["dropoff_or_pickup"] != "dropOff" ) {
      return isCheckboxChecked && isDateSelected && isWeightValid && isAddressEntered;
    } else {
      return isCheckboxChecked && isDateSelected && isWeightValid;
    }
  }

  void submitForm() {
    if (isFormValid()) {
      print(donationFormInput);
      // Perform form submission logic here
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Input"),
            content: Text("Please ensure all required fields are filled out correctly."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void updateDate(DateTime date) {
    setState(() {
      donationFormInput["date"] = date;
    });
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donate to ${widget.donationDrive.name}"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Donation Type", style: TextStyle(color: Colors.black)),
            CheckboxListTile(
              title: const Text('Food'),
              value: donationFormInput["food"],
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  donationFormInput["food"] = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Clothes'),
              value: donationFormInput["clothes"],
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  donationFormInput["clothes"] = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Cash'),
              value: donationFormInput["cash"],
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  donationFormInput["cash"] = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Necessities'),
              value: donationFormInput["necessities"],
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  donationFormInput["necessities"] = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Others'),
              value: donationFormInput["others"],
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  donationFormInput["others"] = value!;
                });
              },
            ),
            Text("Pick up or Drop Off?", style: TextStyle(color: Colors.black)),
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
            Text("Weight of items to donate", style: TextStyle(color: Colors.black)),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: "Enter weight"),
              keyboardType: TextInputType.number,
              onChanged: (String weightValue) => updateWeight(weightValue),
            ),
            Visibility(
              visible: donationFormInput["dropoff_or_pickup"] != "dropOff",
              child: Column(
                children: [
                  Text("Address", style: TextStyle(color: Colors.black)),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: "Enter address"),
                  ),
                  ElevatedButton(
                    onPressed: addAddress,
                    child: Text("Add Address"),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: donationFormInput["addresses"].length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(donationFormInput["addresses"][index]),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => removeAddress(index),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            DatePicker(onDateSelected: updateDate),
            Text("Photos of items (optional)"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              ElevatedButton.icon(
                icon: Icon(Icons.photo_library),
                onPressed: () => {
                  pickImage(ImageSource.gallery)
                },
                label: Text("Pick from Gallery"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: Colors.blue, // Set the text color for the button
                  textStyle: TextStyle(fontSize: 16.0), // Adjust the text size
                  shape: RoundedRectangleBorder( // Create rounded corners
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.camera_alt),
                onPressed: () => {
                  pickImage(ImageSource.camera)
                },
                label: Text("Pick from Camera"), // Change label text for clarity
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: Colors.deepOrange, // Maintain white text color
                  textStyle: TextStyle(fontSize: 16.0), // Consistent text size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Maintain rounded corners
                  ),
                ),
              ),
              ],
            ),
            if (image != null) 
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Image you picked:"),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Image.file(image!, width: 200, height: 200,),
                    ),
                  ],
                ),
                ElevatedButton(onPressed: () => {
                  setState(() {
                    image = null;
                  })
                }, child: Text("Remove Image"))
              ],
            ),
            ElevatedButton(
              onPressed: submitForm,
              child: Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}

class DatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  DatePicker({required this.onDateSelected});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.onDateSelected(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = selectedDate != null
        ? "Selected date: ${DateFormat('MMMM d, yyyy').format(selectedDate!)}"
        : 'Select a date';

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(formattedDate),
          TextButton(
            onPressed: () => _selectDate(context),
            child: Text('Select Date'),
          ),
        ],
      ),
    );
  }
}
