import 'package:flutter/material.dart';
import 'package:indian_currency_to_word/indian_currency_to_word.dart';
import 'package:intl/intl.dart';

class PrepaymentAmountTextfield extends StatefulWidget {
  final Function onChanged;
  final double min;
  final double max;
  const PrepaymentAmountTextfield({
    super.key,
    required this.onChanged,
    required this.min,
    required this.max,
  });

  @override
  State<PrepaymentAmountTextfield> createState() =>
      _PrepaymentAmountTextfieldState();
}

class _PrepaymentAmountTextfieldState
    extends State<PrepaymentAmountTextfield> {
  final TextEditingController _myController = TextEditingController(
    text: '5,000',
  );
  final converter = AmountToWords();
  String? _errorMessage;

  num? _tryParse(String value) {
    if (value.trim().isEmpty) return null;
    try {
      return NumberFormat.decimalPattern('en_IN').parse(value);
    } catch (_) {
      return null;
    }
  }

  void _handleEditComplete() {
    final number = _tryParse(_myController.text);
    if (number == null) {
      setState(() {
        _myController.text = NumberFormat.decimalPattern('en_IN')
            .format(widget.min);
        _errorMessage = null;
      });
      widget.onChanged(widget.min);
      return;
    }
    widget.onChanged(number.toDouble());
    setState(() {
      _myController.text =
          NumberFormat.decimalPattern('en_IN').format(number);
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedNumber = _tryParse(_myController.text);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          const Text(
            'PREPAYMENT AMOUNT',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            spacing: 5,
            children: [
              const Text('₹', style: TextStyle(fontSize: 20)),
              SizedBox(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    errorText: _errorMessage,
                  ),
                  controller: _myController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final number = _tryParse(value);
                    setState(() {
                      if (value.trim().isEmpty) {
                        _errorMessage = null;
                      } else if (number == null) {
                        _errorMessage = 'Invalid amount';
                      } else if (number > widget.max) {
                        _errorMessage = 'Amount exceeds Loan Amount';
                      } else {
                        _errorMessage = null;
                      }
                    });
                  },
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_errorMessage == null) {
                      _handleEditComplete();
                    }
                  },
                  onEditingComplete: () {
                    if (_errorMessage == null) {
                      _handleEditComplete();
                    }
                  },
                ),
              ),
            ],
          ),
          if (displayedNumber != null)
            Text(
              converter.convertAmountToWords(displayedNumber.toDouble()),
            ),
        ],
      ),
    );
  }
}