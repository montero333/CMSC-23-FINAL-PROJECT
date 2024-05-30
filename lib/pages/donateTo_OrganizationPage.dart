import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/image_constants.dart';
import '../providers/donation_provider.dart';
import 'package:provider/provider.dart';
import '../models/donation_drive_model.dart';
import 'package:intl/intl.dart'; // Import the intl package
import '../models/donation_model.dart'; 


class DonateToOrganizationDrive extends StatefulWidget {
  final DonationDrive donationDrive;
  final String? userID;
  DonateToOrganizationDrive({super.key, this.userID, required this.donationDrive});

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
    "deliveryMethod": "pickUp",
    "weight": 0,
    "addresses": [],
    "date": null,
    "time": null,
  };
  List<String> deliveryOptions = ["pickUp", "dropOff"];
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
    bool isTimeSelected = donationFormInput["time"] != null;
    bool isWeightValid = donationFormInput["weight"] > 0;
    bool isAddressEntered = donationFormInput["addresses"].isNotEmpty;

    if ( donationFormInput["deliveryMethod"] != "dropOff" ) {
      return isCheckboxChecked && isDateSelected && isTimeSelected && isWeightValid && isAddressEntered;
    } else {
      return isCheckboxChecked && isDateSelected && isTimeSelected && isWeightValid;
    }
  }

  void submitForm() {
    if (isFormValid()) {
      if (donationFormInput["deliveryMethod"] == "dropOff") {
        donationFormInput["addresses"] = []; //reset address
      }
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Donation"),
          content: Text("Are you sure you want to donate?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close the dialog after submitting the form
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Successful donation!'), // Display a success message
                  ),
                );
                Donation donation = Donation(
                  driveID: widget.donationDrive.id, 
                  userID: widget.userID,
                  food: donationFormInput["food"],
                  clothes: donationFormInput["clothes"],
                  cash: donationFormInput["cash"],
                  necessities: donationFormInput["necessities"],
                  others: donationFormInput["others"],
                  deliveryMethod: donationFormInput["deliveryMethod"],
                  weight: donationFormInput["weight"],
                  addresses: donationFormInput["addresses"],
                  date: DateFormat('yyyy-MM-dd').format(donationFormInput["date"]),
                  time: donationFormInput["time"]?.format(context) ?? "",
                  image: ImageConstants().convertToBase64(image)
                  );
                print(donationFormInput);
                donation.printDetails();
                context.read<DonationProvider>().addDonation(donation);
                
                
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
      
      
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

  void updateTime(TimeOfDay time) {
    setState(() {
      donationFormInput["time"] = time;
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
        title: Text("Donate to ${widget.donationDrive.title}"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Donation Type", 
              style: TextStyle(
                  color: Colors.black, // Set text color
                  fontSize: 16, // Set font size
                  fontWeight: FontWeight.bold, // Set font weight
                )
              ),
            CheckboxListTile(
              title: const Text('Food'),
              value: donationFormInput["food"],
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  donationFormInput["food"] = value!;
                });
              },
              activeColor: Colors.green, // Set the color when checked
              checkColor: Colors.white, // Set the color of the checkmark
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
              activeColor: Colors.green, // Set the color when checked
              checkColor: Colors.white, // Set the color of the checkmark
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
              activeColor: Colors.green, // Set the color when checked
              checkColor: Colors.white, // Set the color of the checkmark
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
              activeColor: Colors.green, // Set the color when checked
              checkColor: Colors.white, // Set the color of the checkmark
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
              value: deliveryOptions[0],
              groupValue: donationFormInput["deliveryMethod"],
              onChanged: (String? value) {
                setState(() {
                  donationFormInput["deliveryMethod"] = value;
                });
              },
              activeColor: Colors.green, // Set the color when selected
              selectedTileColor: Colors.grey[200], // Set the color of the selected tile
            ),
            RadioListTile<String>(
              title: const Text('Drop Off'),
              value: deliveryOptions[1],
              groupValue: donationFormInput["deliveryMethod"],
              onChanged: (String? value) {
                setState(() {
                  donationFormInput["deliveryMethod"] = value;
                });
              },
              activeColor: Colors.green, // Set the color when selected
              selectedTileColor: Colors.grey[200], // Set the color of the selected tile
            ),
            Text(
              "Weight of items to donate",
              style: TextStyle(
                color: Colors.black, // Set text color
                fontSize: 16, // Set font size
                fontWeight: FontWeight.bold, // Set font weight
              ),
            ),

            TextField(
              controller: weightController,
              decoration: InputDecoration(
                labelText: "Enter weight",
                labelStyle: TextStyle(
                  color: Colors.black, // Change the color of the label text
                ),
                border: OutlineInputBorder( // Set border style
                  borderSide: BorderSide(color: Colors.grey), // Set the border color
                  borderRadius: BorderRadius.circular(10.0), // Set border radius
                ),
                focusedBorder: OutlineInputBorder( // Set focused border style
                  borderSide: BorderSide(color: Colors.blue), // Set the focused border color
                  borderRadius: BorderRadius.circular(10.0), // Set focused border radius
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (String weightValue) => updateWeight(weightValue),
              style: TextStyle(
                color: Colors.black, // Change the color of the input text
              ),
            ),

            Visibility(
              visible: donationFormInput["deliveryMethod"] != "dropOff",
              child: Column(
                children: [
                  Text(
                    "Address",
                    style: TextStyle(
                      color: Colors.black, // Set text color
                      fontSize: 16, // Set font size
                      fontWeight: FontWeight.bold, // Set font weight
                    ),
                  ),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: "Enter address",
                      labelStyle: TextStyle(
                          color: Colors.black, // Change the color of the label text
                        ),
                        border: OutlineInputBorder( // Set border style
                          borderSide: BorderSide(color: Colors.grey), // Set the border color
                          borderRadius: BorderRadius.circular(10.0), // Set border radius
                        ),
                        focusedBorder: OutlineInputBorder( // Set focused border style
                          borderSide: BorderSide(color: Colors.blue), // Set the focused border color
                          borderRadius: BorderRadius.circular(10.0), // Set focused border radius
                        ),
                      ),
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
            TimePicker(onTimeSelected: updateTime),
            Text(
              "Photo of items (optional)",
              style: TextStyle(
                      color: Colors.black, // Set text color
                      fontSize: 16, // Set font size
                      fontWeight: FontWeight.bold, // Set font weight
                    )
                ),
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
                }, 
                child: Text("Remove Image"),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, 
                    backgroundColor: Colors.red, // Text color
                    textStyle: TextStyle(fontSize: 16), // Text style
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Button padding
                    shape: RoundedRectangleBorder( // Button border shape
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: submitForm,
              child: Text("Done"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, 
                backgroundColor: Colors.green, // Text color
                textStyle: TextStyle(fontSize: 16), // Text style
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Button padding
                shape: RoundedRectangleBorder( // Button border shape
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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

class TimePicker extends StatefulWidget {
  final Function(TimeOfDay) onTimeSelected;

  TimePicker({required this.onTimeSelected});

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay? selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        widget.onTimeSelected(selectedTime!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = selectedTime != null
        ? "Selected time: ${selectedTime!.format(context)}"
        : 'Select a time';

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(formattedTime),
          TextButton(
            onPressed: () => _selectTime(context),
            child: Text('Select Time'),
          ),
        ],
      ),
    );
  }
}

