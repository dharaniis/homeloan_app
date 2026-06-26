import 'package:flutter/material.dart';
import 'package:homeloan_calc_app/models/emi_models.dart';
import 'package:intl/intl.dart';

class YearlyExpansion extends StatefulWidget {
  final YearSummary summary;

  const YearlyExpansion({super.key, required this.summary});

  @override
  State<YearlyExpansion> createState() => _YearlyExpansionState();
}

class _YearlyExpansionState extends State<YearlyExpansion> {
  late List<EmiMonthRow> monthRows;

  String monthStr(DateTime paymentDate) {
    return DateFormat('MMMM').format(paymentDate);
  }

  @override
  void initState() {
    super.initState();
    monthRows = widget.summary.rows;
  }

  @override
  void didUpdateWidget(covariant YearlyExpansion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.summary != oldWidget.summary) {
      setState(() {
        monthRows = widget.summary.rows;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final cardWidth = (constraints.maxWidth - gap) / 2;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: monthRows.map((row) {
            return SizedBox(
              width: cardWidth,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: row.prepaymentFlag
                        ? const Color(0xFF0F7A3B)
                        : Color(0xFFE0E0E0),
                    width: row.prepaymentFlag ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(
                      monthStr(row.paymentDate),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),],
                    ),
                    

                    Column(
                      children: [
                        const Text(
                          "PRINCIPAL",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        Text(
                          '₹${NumberFormat.decimalPattern("en_IN").format(row.principalPaid.round())}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "INTEREST",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        Text(
                          '₹${NumberFormat.decimalPattern("en_IN").format(row.interestPaid.round())}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    if (row.prepaymentFlag)
                      Column(
                        children: [
                          const Text(
                            "PREPAYMENT",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F7A3B),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '₹${NumberFormat.decimalPattern("en_IN").format(row.prepaymentAmount.round())}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    Column(
                      children: [
                        const Text(
                          "EMI",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF0F7A3B),
                          ),
                        ),
                        Text(
                          '₹${NumberFormat.decimalPattern("en_IN").format(row.emi.round())}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F7A3B),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
