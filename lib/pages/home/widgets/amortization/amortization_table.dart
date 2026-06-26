import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeloan_calc_app/providers/loan_provider.dart';
import 'package:homeloan_calc_app/pages/home/widgets/amortization/yearly_expansion.dart';
import 'package:homeloan_calc_app/pages/home/widgets/amortization/yearly_expansiontable.dart';
import 'package:intl/intl.dart';

class AmortizationTable extends ConsumerStatefulWidget {
  const AmortizationTable({super.key});

  @override
  ConsumerState<AmortizationTable> createState() => _AmortizationTableState();
}

class _AmortizationTableState extends ConsumerState<AmortizationTable> {
  int? expandedIndex;
  bool _showTableView = false; // false = month cards, true = table

  final Map<int, GlobalKey> _itemKeys = {};

  void _handleTap(int index, bool isCurrentlyExpanded) {
    setState(() {
      if (isCurrentlyExpanded) {
        expandedIndex = null;
      } else {
        expandedIndex = index;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetKey = _itemKeys[index];
      final targetContext = targetKey?.currentContext;

      if (targetContext != null) {
        Scrollable.ensureVisible(
          targetContext,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.0,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loanState = ref.watch(loanControllerProvider);
    final summaries = loanState.summaries;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Amortization Breakdowns",
            style: TextStyle(fontSize: 25),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showTableView = !_showTableView;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "View Mode",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          _showTableView
                              ? "Showing yearly breakdown table"
                              : "Showing monthly cards",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  _showTableView ? "Table" : "Cards",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F7A3B),
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: _showTableView,
                  activeThumbColor: const Color(0xFF0F7A3B),
                  onChanged: (value) {
                    setState(() {
                      _showTableView = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: summaries.length,
          itemBuilder: (context, index) {
            final summary = summaries[index];
            final expanded = expandedIndex == index;

            final itemKey = _itemKeys.putIfAbsent(index, () => GlobalKey());

            return Container(
              key: itemKey,
              margin: const EdgeInsets.only(bottom: 20),
              child: Material(
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Colors.black),
                ),
                elevation: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => _handleTap(index, expanded),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'YEAR ${summary.year}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Color(0xFF0F7A3B),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        'EMI: ',
                                        style: TextStyle(
                                          color: Color(0xFF47484f),
                                        ),
                                      ),
                                      Text(
                                        '₹${NumberFormat.decimalPattern('en_IN').format(summary.totalEmi.round())} | ',
                                        style: const TextStyle(
                                          color: Color(0xFF47484f),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'Paid: ',
                                        style: TextStyle(
                                          color: Color(0xFF47484f),
                                        ),
                                      ),
                                      Text(
                                        '₹${NumberFormat.decimalPattern('en_IN').format(summary.totalPaid.round())}',
                                        style: const TextStyle(
                                          color: Color(0xFF47484f),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              expanded ? Icons.expand_less : Icons.expand_more,
                              color: const Color(0xFF0b1c30),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (expanded) ...[
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.black,
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Padding(
                          key: ValueKey('${summary.year}-$_showTableView'),
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: _showTableView
                              ? YearlyExpansionTable(summary: summary)
                              : YearlyExpansion(summary: summary),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
