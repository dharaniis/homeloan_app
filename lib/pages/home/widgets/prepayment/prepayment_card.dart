import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeloan_calc_app/models/emi_models.dart';
import 'package:homeloan_calc_app/providers/loan_provider.dart';
import 'package:homeloan_calc_app/pages/home/widgets/prepayment/onetime_prepayment_form.dart';
import 'package:homeloan_calc_app/pages/home/widgets/prepayment/recurring_prepayment_form.dart';

class PrepaymentCard extends ConsumerWidget {
  const PrepaymentCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanState = ref.watch(loanControllerProvider);
    final loanController = ref.read(loanControllerProvider.notifier);
    final loanInput = loanState.loanInput;

    final enablePrepayment = loanInput.enablePrepayment;
    final prepaymentType = loanInput.prepaymentType ?? PrepaymentType.oneTime;
    final prepaymentStrategy = loanInput.prepaymentStrategy ?? PrepaymentStrategy.reduceTenure;
    final prepaymentMonth = loanInput.prepaymentMonth ?? 1;

    return Container(
      padding: enablePrepayment
          ? EdgeInsets.symmetric(horizontal: 10, vertical: 15)
          : EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              loanController.togglePrepayment(!enablePrepayment);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ENABLE PREPAYMENT ?",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  Switch(
                    value: enablePrepayment,
                    activeThumbColor: const Color(0xFF0F7A3B),
                    onChanged: (value) {
                      loanController.togglePrepayment(value);
                    },
                  ),
                ],
              ),
            ),
          ),

          if (enablePrepayment)
            Column(
              spacing: 10,
              children: [
                RadioGroup<PrepaymentType>(
                  groupValue: prepaymentType,
                  onChanged: (value) {
                    if (value != null) {
                      loanController.updatePrepaymentType(value);
                    }
                  },
                  child: Column(
                    children: [
                      RadioListTile<PrepaymentType>(
                        title: const Text('One Time'),
                        value: PrepaymentType.oneTime,
                      ),
                      RadioListTile<PrepaymentType>(
                        title: const Text('Recurring'),
                        value: PrepaymentType.recurring,
                      ),
                    ],
                  ),
                ),

                RadioGroup<PrepaymentStrategy>(
                  groupValue: prepaymentStrategy,
                  onChanged: (value) {
                    if (value != null) {
                      loanController.updatePrepaymentStrategy(value);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 0,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text(
                          "PREPAYMENT STRATEGY ",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                      RadioListTile<PrepaymentStrategy>(
                        title: const Text('Reduce tenure (keep EMI same)'),
                        value: PrepaymentStrategy.reduceTenure,
                      ),
                      RadioListTile<PrepaymentStrategy>(
                        title: const Text('Reduce EMI (keep tenure same)'),
                        value: PrepaymentStrategy.reduceEMI,
                      ),
                    ],
                  ),
                ),

                (prepaymentType == PrepaymentType.oneTime)
                    ? OneTimePrepaymentForm(
                        loanAmount: loanInput.principal,
                        tenureMonths: loanInput.tenureMonths.toDouble(),
                        loanDate: loanInput.startDate,
                        prepaymentMonth: prepaymentMonth,
                        onAmountChange: (value) {
                          loanController.updatePrepaymentAmount(value);
                        },
                        onMonthChange: (value) {
                          loanController.updatePrepaymentMonth(value.toInt());
                        },
                      )
                    : RecurringPrepaymentForm(
                        loanAmount: loanInput.principal,
                        onAmountChange: (value) {
                          loanController.updatePrepaymentAmount(value);
                        },
                        onPrepaymentFrequencyChanged: (value) {
                          loanController.updatePrepaymentFrequency(value);
                        },
                      ),
              ],
            ),
        ],
      ),
    );
  }
}
