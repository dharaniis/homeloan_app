import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeloan_calc_app/providers/loan_provider.dart';
import 'package:homeloan_calc_app/models/emi_models.dart';
import 'package:homeloan_calc_app/pages/home/pdfviewpage.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class GeneratePdf extends ConsumerWidget {
  const GeneratePdf({super.key});

  Future<pw.Document> buildEmiSchedulePdf(
    List<YearSummary> yearSummaries,
    LoanInput loanInput,
  ) async {
    final pdf = pw.Document(title: 'loan_summary_report');

    final amountFormat = NumberFormat('#,##,##0', 'en_IN');
    final generatedDate = DateFormat('MMM d, yyyy').format(DateTime.now());

    String amount(num value) => amountFormat.format(value.round());

    String prepaymentTypeText() {
      if (!loanInput.enablePrepayment) return 'Disabled';
      return (loanInput.prepaymentType == PrepaymentType.oneTime)
          ? 'One Time'
          : 'Recurring';
    }

    String prepaymentStrategyText() {
      if (!loanInput.enablePrepayment) return '-';
      if (loanInput.prepaymentStrategy == null) return '-';

      return (loanInput.prepaymentStrategy == PrepaymentStrategy.reduceEMI)
          ? 'Reduce EMI'
          : 'Reduce Tenure';
    }

    String prepaymentAmountText() {
      if (!loanInput.enablePrepayment || loanInput.prepaymentAmount == null) {
        return '-';
      }
      return amount(loanInput.prepaymentAmount!);
    }

    String prepaymentFrequencyText() {
      if (!loanInput.enablePrepayment) return '-';
      if (loanInput.prepaymentFrequency == null) return '-';

      final freq = loanInput.prepaymentFrequency!;
      if (freq == 12) return 'Every year';
      if (freq == 6) return 'Every 6 months';
      if (freq == 3) return 'Every 3 months';
      if (freq == 1) return 'Every month';

      return 'Every ${freq.toStringAsFixed(0)} months';
    }

    final allRows = yearSummaries
        .expand(
          (yearSummary) => yearSummary.rows.map(
            (row) => {'year': yearSummary.year, 'row': row},
          ),
        )
        .toList();

    final monthlyEmi = allRows.isNotEmpty
        ? (allRows.first['row'] as EmiMonthRow).emi
        : 0.0;

    final totalPrincipal = allRows.fold<double>(
      0,
      (sum, entry) => sum + ((entry['row'] as EmiMonthRow).principalPaid),
    );

    final totalInterest = allRows.fold<double>(
      0,
      (sum, entry) => sum + ((entry['row'] as EmiMonthRow).interestPaid),
    );

    final totalPrepayment = allRows.fold<double>(
      0,
      (sum, entry) => sum + ((entry['row'] as EmiMonthRow).prepaymentAmount),
    );

    final totalEmi = allRows.fold<double>(
      0,
      (sum, entry) => sum + ((entry['row'] as EmiMonthRow).emi),
    );

    final finalBalance = allRows.isNotEmpty
        ? (allRows.last['row'] as EmiMonthRow).closingBalance
        : 0.0;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(24, 24, 24, 36),
        footer: (context) => pw.Container(
          margin: const pw.EdgeInsets.only(top: 24),
          padding: const pw.EdgeInsets.only(top: 16),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Expanded(
                child: pw.Text(
                  'Disclaimer: This report is a simulation and does not constitute a legal financial offer. Actual figures may vary based on bank-specific policies, floating interest rates, and additional taxes or processing fees.',
                  style: const pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
              pw.SizedBox(width: 16),
              pw.Text(
                'Page ${context.pageNumber.toString().padLeft(2)} of ${context.pagesCount.toString().padLeft(2)}',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey800,
                ),
              ),
            ],
          ),
        ),
        build: (context) => [
          pw.Text(
            'Loan Summary Report',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Generated on $generatedDate',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 28),

          pw.Text(
            'Loan Parameters',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blueGrey900,
            ),
          ),
          pw.SizedBox(height: 12),

          pw.Row(
            children: [
              pw.Expanded(
                child: _infoCard(
                  title: 'PRINCIPAL AMOUNT',
                  value: amount(loanInput.principal),
                  valueColor: PdfColors.black,
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: _infoCard(
                  title: 'MONTHLY EMI',
                  value: amount(monthlyEmi),
                  valueColor: PdfColors.green800,
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: _infoCard(
                  title: 'INTEREST RATE',
                  value: '${loanInput.annualInterestRate.toStringAsFixed(2)}%',
                  valueColor: PdfColors.black,
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: _infoCard(
                  title: 'LOAN TENURE',
                  value: '${loanInput.tenureYears} Years',
                  valueColor: PdfColors.black,
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          if (loanInput.enablePrepayment) ...[
            _sectionHeader('Prepayment Configuration'),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: const pw.BorderRadius.only(
                  bottomLeft: pw.Radius.circular(8),
                  bottomRight: pw.Radius.circular(8),
                ),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: _configItem('PREPAYMENT TYPE', prepaymentTypeText()),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    child: _configItem(
                      'PREPAYMENT STRATEGY',
                      prepaymentStrategyText(),
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    child: _configItem(
                      'PREPAYMENT AMOUNT',
                      prepaymentAmountText(),
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    child: _configItem(
                      'PREPAYMENT FREQUENCY',
                      prepaymentFrequencyText(),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 28),
          ],

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Payment Schedule',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey900,
                ),
              ),
              pw.Text(
                'All values in INR',
                style: pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey700,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder(
              horizontalInside: pw.BorderSide.none,
              verticalInside: pw.BorderSide.none,
              top: pw.BorderSide.none,
              bottom: pw.BorderSide.none,
              left: pw.BorderSide.none,
              right: pw.BorderSide.none,
            ),
            columnWidths: {
              0: const pw.FixedColumnWidth(44),
              1: const pw.FixedColumnWidth(78),
              2: const pw.FlexColumnWidth(1.2),
              3: const pw.FlexColumnWidth(1.2),
              4: const pw.FlexColumnWidth(1.1),
              5: const pw.FlexColumnWidth(1.5),
              6: const pw.FlexColumnWidth(1.0),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue100,
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                children: [
                  _headerCell('Year'),
                  _headerCell('Month'),
                  _headerCell('Principal Paid'),
                  _headerCell('Interest Paid'),
                  _headerCell('Prepayment'),
                  _headerCell('Remaining Balance'),
                  _headerCell('EMI'),
                ],
              ),
              ...allRows.map((entry) {
                final year = entry['year'] as int;
                final row = entry['row'] as EmiMonthRow;
                final hasPrepayment = row.prepaymentAmount > 0;

                return pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: hasPrepayment ? PdfColors.green50 : PdfColors.white,
                  ),
                  children: [
                    _bodyCell(year.toString()),
                    _bodyCell(DateFormat('MMMM').format(row.paymentDate)),
                    _bodyCell(amount(row.principalPaid)),
                    _bodyCell(amount(row.interestPaid)),
                    _bodyCell(
                      hasPrepayment ? amount(row.prepaymentAmount) : '0',
                    ),
                    _bodyCell(amount(row.closingBalance)),
                    _bodyCell(amount(row.emi), textColor: PdfColors.green800),
                  ],
                );
              }),
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.blueGrey50),
                children: [
                  _totalCell(''),
                  _totalCell('Total'),
                  _totalCell(amount(totalPrincipal)),
                  _totalCell(amount(totalInterest)),
                  _totalCell(amount(totalPrepayment)),
                  _totalCell(amount(finalBalance)),
                  _totalCell(amount(totalEmi), textColor: PdfColors.green800),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _infoCard({
    required String title,
    required String value,
    required PdfColor valueColor,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: pw.BoxDecoration(
        color: PdfColors.blueGrey50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _sectionHeader(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue100,
        borderRadius: const pw.BorderRadius.only(
          topLeft: pw.Radius.circular(8),
          topRight: pw.Radius.circular(8),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blueGrey900,
        ),
      ),
    );
  }

  static pw.Widget _configItem(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blueGrey900,
          ),
        ),
      ],
    );
  }

  static pw.Widget _headerCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blueGrey900,
        ),
      ),
    );
  }

  static pw.Widget _bodyCell(
    String text, {
    PdfColor textColor = PdfColors.blueGrey900,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: pw.Text(text, style: pw.TextStyle(fontSize: 9, color: textColor)),
    );
  }

  static pw.Widget _totalCell(
    String text, {
    PdfColor textColor = PdfColors.blueGrey900,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanState = ref.watch(loanControllerProvider);
    final summaries = loanState.summaries;
    final loanInput = loanState.loanInput;

    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed: () async {
        final pdf = await buildEmiSchedulePdf(summaries, loanInput);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pdfViewPage(pdf: pdf)),
        );
      },
      child: Icon(Icons.share),
    );
  }
}
