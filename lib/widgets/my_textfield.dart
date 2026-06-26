import 'package:flutter/material.dart';
import 'package:indian_currency_to_word/indian_currency_to_word.dart';
import 'package:intl/intl.dart';

class MyTextField extends StatefulWidget {
  final Function onChanged;
  final double min;
  final double max;
  final double currentValue;
  final String symbol;

  const MyTextField({
    super.key,
    required this.onChanged,
    required this.currentValue,
    required this.min,
    required this.max,
    required this.symbol,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late final TextEditingController _myController;
  final converter = AmountToWords();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _myController = TextEditingController(
      text: NumberFormat.decimalPattern('en_IN').format(widget.currentValue),
    );
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MyTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentValue != oldWidget.currentValue) {
      setState(() {
        _myController.text = NumberFormat.decimalPattern(
          'en_IN',
        ).format(widget.currentValue);
        if (widget.currentValue > widget.max) {
            _errorMessage = 'Exceeding limits';
          } else {
            _errorMessage = null;
          }
      });
    }
  }

  void _handleEditComplete() {
    num number = NumberFormat.decimalPattern('en_IN').parse(_myController.text);
    widget.onChanged(number.toDouble());
    setState(() {
      _myController.text = NumberFormat.decimalPattern('en_IN').format(number);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFD9DCE5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFB8BEC9), width: 1),
              ),
              child: Row(
                children: [
                  if (widget.symbol == '₹')
                    Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Text(
                        widget.symbol,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2B3548),
                        ),
                      ),
                    ),
                  Expanded(
                    child: TextField(
                      controller: _myController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2D3D),
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isCollapsed: true,
                      ),
                      onChanged: (value) {
                        num number = NumberFormat.decimalPattern(
                          'en_IN',
                        ).parse(value);
                        setState(() {
                          if (number >= widget.max) {
                            _errorMessage = 'Exceeding limits';
                          } else if (number < widget.min){
                            _errorMessage = 'Lower than minimum';
                          }else {
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
                      onSubmitted: (value) {
                        if (_errorMessage == null) {
                          _handleEditComplete();
                        }
                      },
                    ),
                  ),
                  if (widget.symbol != '₹')
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        widget.symbol,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF2B3548),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: const Color.fromARGB(255, 227, 37, 23),
                  fontSize: (widget.symbol == '₹') ? 10 : 8,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
