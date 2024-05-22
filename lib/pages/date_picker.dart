import 'package:flutter/material.dart';

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
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(selectedDate == null
                ? 'Select a date'
                : 'Selected date: ${selectedDate!.toIso8601String()}'),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
          ],
        ),
      );
  }
}
