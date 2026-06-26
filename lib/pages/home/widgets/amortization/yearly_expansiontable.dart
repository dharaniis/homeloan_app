import 'package:flutter/material.dart';
import 'package:homeloan_calc_app/models/emi_models.dart';
import 'package:intl/intl.dart';

class YearlyExpansionTable extends StatelessWidget {
  final YearSummary summary;

  const YearlyExpansionTable({
    super.key,
    required this.summary,
  });

  String monthStr(DateTime paymentDate) {
    return DateFormat('MMMM').format(paymentDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        border: Border(
          left: BorderSide(color: Color(0xFFE0E0E0)),
          right: BorderSide(color: Color(0xFFE0E0E0)),
          bottom: BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
      padding: const EdgeInsets.all(5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          headingRowColor: WidgetStateProperty.all(const Color(0xFFeff4ff)),
          dividerThickness: 0.5,
          horizontalMargin: 12,
          dataRowMinHeight: 40,
          headingRowHeight: 45,
          columns: [
            DataColumn(
              label: Text(
                'MONTH',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'PRINCIPAL',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'INTEREST',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'PREPAYMENT',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'BALANCE',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'EMI',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ],
          rows: summary.rows.map((monthRow) {
            return DataRow(
              color: WidgetStateProperty.resolveWith<Color?>((states) {
                if (monthRow.prepaymentFlag) {
                  return const Color(0xFFf0fef8);
                }
                return null;
              }),
              cells: [
                DataCell(Text(monthStr(monthRow.paymentDate))),
                DataCell(
                  Text(
                    '₹${NumberFormat.decimalPattern('en_IN').format(monthRow.principalPaid.round())}',
                  ),
                ),
                DataCell(
                  Text(
                    '₹${NumberFormat.decimalPattern('en_IN').format(monthRow.interestPaid.round())}',
                  ),
                ),
                DataCell(
                  Center(
                    child: monthRow.prepaymentFlag
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F7A3B),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '₹${NumberFormat.decimalPattern('en_IN').format(monthRow.prepaymentAmount.round())}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : const Text('-', textAlign: TextAlign.center),
                  ),
                ),
                DataCell(
                  Text(
                    '₹${NumberFormat.decimalPattern('en_IN').format(monthRow.closingBalance.round())}',
                  ),
                ),
                DataCell(
                  Text(
                    '₹${NumberFormat.decimalPattern('en_IN').format(monthRow.emi.round())}',
                    style: const TextStyle(color: Color(0xff006c49)),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
