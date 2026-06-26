import 'package:flutter/material.dart';
import 'package:homeloan_calc_app/pages/home/widgets/prepayment/prepaymentamount_textfield.dart';
import 'package:homeloan_calc_app/pages/home/widgets/prepayment/prepaymentfrequency_dropdown.dart';


class RecurringPrepaymentForm extends StatelessWidget {
  final double loanAmount;
  final Function onAmountChange;
  final Function onPrepaymentFrequencyChanged;

  const RecurringPrepaymentForm({
    super.key,
    required this.loanAmount,
    required this.onAmountChange,
    required this.onPrepaymentFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrepaymentAmountTextfield(
          min: 0,
          max: loanAmount,
          onChanged: (value) {
            onAmountChange(value);
          },
        ),
        PrepaymentfrequencyDropdown(
          onChanged: (value) {
            onPrepaymentFrequencyChanged(value);
          },
        ),
      ],
    );
  }
}
