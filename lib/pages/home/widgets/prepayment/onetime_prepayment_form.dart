import 'package:flutter/material.dart';
import 'package:homeloan_calc_app/pages/home/widgets/prepayment/onetime_monthpicker.dart';
import 'package:homeloan_calc_app/pages/home/widgets/prepayment/prepaymentamount_textfield.dart';

class OneTimePrepaymentForm extends StatelessWidget {
  final double loanAmount;
  final double tenureMonths;
  final DateTime loanDate;
  final int prepaymentMonth;
  final Function onAmountChange;
  final Function onMonthChange;

  const OneTimePrepaymentForm({
    super.key,
    required this.loanAmount,
    required this.tenureMonths,
    required this.loanDate,
    required this.prepaymentMonth,
    required this.onAmountChange,
    required this.onMonthChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrepaymentAmountTextfield(
          min: 0,
          max: loanAmount,
          onChanged: (value) {
            onAmountChange(value);
          },
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PREPAYMENT MONTH",
                style: TextStyle(
                  fontSize: 15, color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              OneTimeMonthPicker(
                startDate: DateTime(
                  loanDate.year,
                  loanDate.month + prepaymentMonth - 1,
                ),
                firstDate: DateTime(loanDate.year, loanDate.month),
                lastDate: DateTime(
                  loanDate.year,
                  loanDate.month + tenureMonths.toInt() - 1,
                ),
                onChanged: (value) {
                  int monthNum = DateUtils.monthDelta(loanDate, value) + 1;
                  onMonthChange(monthNum);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
