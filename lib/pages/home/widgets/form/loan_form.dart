import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeloan_calc_app/providers/loan_provider.dart';
import 'package:homeloan_calc_app/pages/home/widgets/prepayment/prepayment_card.dart';
import 'package:homeloan_calc_app/pages/home/widgets/form/slider_field.dart';
import 'package:homeloan_calc_app/pages/home/widgets/form/startdate_card.dart';
import 'package:intl/intl.dart';

class LoanForm extends ConsumerWidget {
  const LoanForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanState = ref.watch(loanControllerProvider);
    final loanController = ref.read(loanControllerProvider.notifier);
    final loanInput = loanState.loanInput;

    return Column(
      spacing: 20,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            spacing: 25,
            children: [
              SliderField(
                title: "Loan Amount ",
                currentValue: loanInput.principal,
                min: 100000,
                max: 100000000,
                divisions: 999,
                minLabel: '1L',
                maxLabel: '10Cr',
                isCurrency: true,
                onChanged: (value) {
                  loanController.updatePrincipal(value.roundToDouble());
                },
                symbol: '₹',
                valueFormatter: (value) =>
                    '₹${NumberFormat.decimalPattern('en_IN').format(value.round())}',
              ),
              SliderField(
                title: "Tenure ",
                currentValue: loanInput.tenureYears.toDouble(),
                min: 1,
                max: 30,
                minLabel: '1Y',
                maxLabel: '30Y',
                symbol: 'Y',
                divisions: 29,
                onChanged: (value) {
                  loanController.updateTenure(value.round());
                },
                valueFormatter: (value) => value.round() == 1
                    ? '${value.round()} year'
                    : '${value.round()} years',
              ),
              SliderField(
                title: "Rate of Interest ",
                currentValue: loanInput.annualInterestRate,
                min: 7,
                max: 15,
                minLabel: '7 %',
                maxLabel: '15 %',
                symbol: '%',
                divisions: 80,
                onChanged: (value) {
                  loanController.updateRate(double.parse(value.toStringAsFixed(2)));
                },
                valueFormatter: (value) => '${value.toStringAsFixed(2)}%',
              ),
              StartdateCard(
                startDate: loanInput.startDate,
                onChanged: (value) {
                  loanController.updateStartDate(value);
                },
              ),
              const PrepaymentCard(),
            ],
          ),
        ),
      ],
    );
  }
}
