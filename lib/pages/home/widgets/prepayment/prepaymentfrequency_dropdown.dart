import 'package:flutter/material.dart';
import 'package:homeloan_calc_app/models/emi_models.dart';

class PrepaymentfrequencyDropdown extends StatefulWidget {
  final Function onChanged;
  const PrepaymentfrequencyDropdown({super.key, required this.onChanged});

  @override
  State<PrepaymentfrequencyDropdown> createState() =>
      _PrepaymentfrequencyDropdownState();
}

class _PrepaymentfrequencyDropdownState
    extends State<PrepaymentfrequencyDropdown> {
  PrepaymentFrequency? selectedFrequency = PrepaymentFrequency.every6Months;

  @override
  Widget build(BuildContext context) {
    return Padding(
             padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Text(
            "Prepayment Frequency",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          DropdownMenu<PrepaymentFrequency>(
            selectOnly: true,
            initialSelection: selectedFrequency,
            dropdownMenuEntries: PrepaymentFrequency.values.map((
              PrepaymentFrequency frequency,
            ) {
              return DropdownMenuEntry<PrepaymentFrequency>(
                value: frequency,
                label: frequency.displayLabel,
              );
            }).toList(),
            onSelected: (PrepaymentFrequency? newValue) {
              setState(() {
                double value = newValue!.value;
                widget.onChanged(value);
              });
            },
          ),
        ],
      ),
    );
  }
}
