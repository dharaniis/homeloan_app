import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OneTimeMonthPicker extends StatefulWidget {
  final DateTime startDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function onChanged;
  const OneTimeMonthPicker({
    super.key,
    required this.firstDate,
    required this.startDate,
    required this.lastDate,
    required this.onChanged,
  });

  @override
  State<OneTimeMonthPicker> createState() => _OneTimeMonthPickerState();
}

class _OneTimeMonthPickerState extends State<OneTimeMonthPicker> {
  late DateTime startDate;
  late DateTime firstDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.startDate;
    firstDate = widget.firstDate;
  }

  @override
  void didUpdateWidget(covariant OneTimeMonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.firstDate != oldWidget.firstDate) {
        firstDate = widget.firstDate;
      bool needsClamp = startDate.isBefore(firstDate) || startDate.isAfter(widget.lastDate);
      if (needsClamp) {
        startDate = firstDate;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {});
          widget.onChanged(startDate);
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {});
        });
      }
    }

    if (widget.startDate != oldWidget.startDate) {
      startDate = widget.startDate;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {});
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime initial = startDate;
    if (initial.isBefore(firstDate)) initial = firstDate;
    if (initial.isAfter(widget.lastDate)) initial = widget.lastDate;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
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
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            DateFormat('MMMM y').format(startDate),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
