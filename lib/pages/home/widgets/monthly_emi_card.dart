import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeloan_calc_app/providers/loan_provider.dart';
import 'package:intl/intl.dart';

class MonthlyEmiCard extends ConsumerWidget {
  const MonthlyEmiCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanState = ref.watch(loanControllerProvider);
    final result = loanState.result;
    final emi = result.emi;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFFE0E0E0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "ESTIMATED MONTLY EMI",
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '₹${NumberFormat.decimalPattern('en_IN').format(emi.round())}',
                    style: TextStyle(
                      fontSize: 45,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Divider(color: Color.fromARGB(72, 100, 116, 139)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Interest Paid",
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        Text(
                          '₹${NumberFormat.decimalPattern('en_IN').format(result.totalInterest.round())}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount Paid",
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        Text(
                          '₹${NumberFormat.decimalPattern('en_IN').format(result.totalPayment.round())}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
