import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class pdfViewPage extends StatelessWidget {
  final pw.Document pdf;
  const pdfViewPage({super.key, required this.pdf});


  Future<void> _sharePdf() async {
    final bytes = await pdf.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'loan_summary_report.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loan Summary Report"),
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        actions: [IconButton(
          icon:  Icon(Icons.share),
          onPressed: _sharePdf,
          )],
      ),
      body: PdfPreview(
        pdfPreviewPageDecoration: BoxDecoration(
          color: Colors.white
        ),
        build: (format) => pdf.save(),
        canChangePageFormat: false,
        canDebug: false,
        canChangeOrientation: false,
        allowPrinting: false,
        allowSharing: false,
        enableScrollToPage: true,
      ),
    );
  }
}
