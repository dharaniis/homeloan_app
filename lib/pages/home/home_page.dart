import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeloan_calc_app/pages/home/generate_pdf.dart';
import 'package:homeloan_calc_app/pages/home/widgets/amortization/amortization_table.dart';
import 'package:homeloan_calc_app/pages/home/widgets/form/loan_form.dart';
import 'package:homeloan_calc_app/pages/home/widgets/monthly_emi_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/unnamed.png'), width: 35),
            Text(
              'Home Loan EMI Calculator',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              spacing: 20,
              children: [
                const MonthlyEmiCard(),
                const LoanForm(),
                Divider(color: Colors.grey),
                const AmortizationTable(),
                SizedBox(height: MediaQuery.of(context).size.height*0.04,)
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const GeneratePdf()
    );
  }
}
