import 'package:flutter/material.dart';

class DuePaymentDialog extends StatefulWidget {
  final Function(DateTime) onSubmit;

  DuePaymentDialog({required this.onSubmit});

  @override
  _DuePaymentDialogState createState() => _DuePaymentDialogState();
}

class _DuePaymentDialogState extends State<DuePaymentDialog> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Due Payment Date'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarDatePicker(
            initialDate: _selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(2101),
            onDateChanged: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Submit'),
          onPressed: () {
            widget.onSubmit(_selectedDate);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
