import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanDatePicker extends StatefulWidget {
  final DateTime startDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function onChanged;
  const LoanDatePicker({
    super.key,
    required this.firstDate,
    required this.startDate,
    required this.lastDate,
    required this.onChanged,
  });

  @override
  State<LoanDatePicker> createState() => _LoanDatePickerState();
}

class _LoanDatePickerState extends State<LoanDatePicker> {
  late DateTime startDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.startDate;
  }


  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.startDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    setState(() {
      if (pickedDate != null) {
        startDate = pickedDate;
        widget.onChanged(pickedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: <Widget>[
        Text(
          DateFormat('MMMM y').format(startDate),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        OutlinedButton(
          onPressed: _selectDate,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              Icon(Icons.calendar_month),
              Text(
                'Select Date',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
