import 'package:flutter/material.dart';
import 'package:homeloan_calc_app/widgets/my_textfield.dart';
import 'package:indian_currency_to_word/indian_currency_to_word.dart';

class SliderField extends StatefulWidget {
  final String title;
  final double currentValue;
  final double min;
  final double max;
  final String? minLabel;
  final String? maxLabel;
  final int? divisions;
  final Function onChanged;
  final String Function(double value)? valueFormatter;
  final bool isCurrency;
  final String symbol;

  const SliderField({
    super.key,
    required this.title,
    required this.symbol,
    required this.currentValue,
    required this.min,
    required this.max,
    this.minLabel,
    this.maxLabel,
    this.divisions,
    required this.onChanged,
    this.valueFormatter,
    this.isCurrency = false,
  });

  @override
  State<SliderField> createState() => _SliderFieldState();
}

class _SliderFieldState extends State<SliderField> {
  late double _currentValue;
  final converter = AmountToWords();

  void handleSliderChanged(double value) {
    setState(() {
      _currentValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentValue = widget.currentValue;
  }

  @override
  void didUpdateWidget(covariant SliderField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentValue != oldWidget.currentValue) {
      setState(() {
        _currentValue = widget.currentValue;
      });
    }
  }

  double getRoundedValue(double amount) {
  if (amount < 10000000) {
    return (amount / 1000).round() * 1000;
  } else {
    return (amount / 100000).round() * 100000;
  }
}

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.isCurrency ? 2 : 2.2,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black),

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: (widget.symbol == '₹') ? 150 : 100,
                    child: MyTextField(currentValue: _currentValue,onChanged: (value) => widget.onChanged(value), min: widget.min, max: widget.max, symbol: widget.symbol,)
                  )
                ],
              ),
            ),
            Slider(
              value: _currentValue,
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions,
              onChanged: handleSliderChanged,
              onChangeEnd: (value) => widget.onChanged(value),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.minLabel ?? widget.min.toString()),
                  Text(widget.maxLabel ?? widget.max.toString()),
                ],
              ),
            ),
            if (widget.isCurrency)
              Text(converter.convertAmountToWords(getRoundedValue(_currentValue)), style: TextStyle(fontStyle: FontStyle.italic,)),
          ],
        ),
      ),
    );
  }
}
