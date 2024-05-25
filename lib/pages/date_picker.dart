import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

class DatePicker extends StatefulWidget {
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),  // Optional initial date (default is today)
      firstDate: DateTime(2015, 8), // Optional first allowed date (e.g., 2015-08-01)
      lastDate: DateTime(2100),   // Optional last allowed date (e.g., 2100-12-31)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
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
