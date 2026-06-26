import 'package:flutter/material.dart';
import 'package:homeloan_calc_app/pages/home/widgets/form/loan_datepicker.dart';

class StartdateCard extends StatelessWidget {
  final DateTime startDate;
  final Function onChanged;

  const StartdateCard({
    super.key,
    required this.startDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.5,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("LOAN START MONTH", style: TextStyle(color: Colors.grey)),
            LoanDatePicker(
              startDate: startDate,
              firstDate: DateTime(2015),
              lastDate: DateTime(startDate.year, startDate.month + 24),
              onChanged: (value) {
                onChanged(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
