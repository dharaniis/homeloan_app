import 'dart:math';
import 'package:homeloan_calc_app/models/emi_models.dart';

class EmiCalculator {
  EmiResult calculate(LoanInput loanInput) {
    final double p = loanInput.principal.toDouble();
    final int n = loanInput.tenureMonths;
    final DateTime startDate = loanInput.startDate;
    final double r = loanInput.monthlyRate;
    final bool enablePrepayment = loanInput.enablePrepayment;
    final double inputPrepaymentAmount = loanInput.prepaymentAmount ?? 0;
    final int? prepaymentMonth = loanInput.prepaymentMonth;
    final double? prepaymentFrequency = loanInput.prepaymentFrequency;
    final PrepaymentStrategy? prepaymentStrategy = loanInput.prepaymentStrategy;
    final PrepaymentType? prepaymentType = loanInput.prepaymentType;

    late double originalEmi;

    if (r == 0) {
      originalEmi = p / n;
    } else {
      final onePlusR = 1 + r;
      final powTerm = pow(onePlusR, n);
      originalEmi = p * r * powTerm / (powTerm - 1);
    }

    double balance = p;
    double totalInterest = 0;
    final List<EmiMonthRow> schedule = [];
    double currentEmi = originalEmi;

    for (int month = 0; month < n; month++) {
      final openingBalance = balance;
      final interestForThisMonth = openingBalance * r;
      final totalToClose = openingBalance + interestForThisMonth;

      // Determine if it is a prepayment month
      bool isPrepaymentMonth = false;
      if (enablePrepayment && inputPrepaymentAmount > 0) {
        if (prepaymentType == PrepaymentType.oneTime &&
            (month + 1) == prepaymentMonth) {
          isPrepaymentMonth = true;
        } else if (prepaymentType == PrepaymentType.recurring &&
            (prepaymentFrequency != null) &&
            ((month + 1) % prepaymentFrequency == 0)) {
          isPrepaymentMonth = true;
        }
      }

      double actualEmiPaid = 0;
      double principalFromEmi = 0;
      double interestPaid = interestForThisMonth;
      double actualPrepayment = 0;
      double closingBalance = 0;

      // Skip EMI Condition: Prepayment is enough to close everything
      // Use a small epsilon to handle floating point precision
      if (isPrepaymentMonth && inputPrepaymentAmount >= (totalToClose - 0.01)) {
        actualEmiPaid = 0;
        principalFromEmi = 0;
        interestPaid = interestForThisMonth;
        actualPrepayment = totalToClose;
        closingBalance = 0;
      } else {
        // Standard Waterfall: Pay interest, then EMI principal, then prepayment
        interestPaid = interestForThisMonth;

        principalFromEmi = currentEmi - interestPaid;
        if (principalFromEmi > openingBalance) {
          principalFromEmi = openingBalance;
        }
        if (principalFromEmi < 0) principalFromEmi = 0;

        actualEmiPaid = interestPaid + principalFromEmi;
        double balanceAfterEmi = openingBalance - principalFromEmi;

        if (isPrepaymentMonth) {
          actualPrepayment = inputPrepaymentAmount;
          if (actualPrepayment > balanceAfterEmi) {
            actualPrepayment = balanceAfterEmi;
          }
        }
        closingBalance = balanceAfterEmi - actualPrepayment;
      }

      // If Strategy is Reduce EMI, recalculate for next month
      if (prepaymentStrategy == PrepaymentStrategy.reduceEMI &&
          isPrepaymentMonth &&
          closingBalance > 0 &&
          r > 0) {
        final remainingMonths = n - (month + 1);
        if (remainingMonths > 0) {
          final onePlusR = 1 + r;
          final powTerm = pow(onePlusR, remainingMonths);
          currentEmi = closingBalance * r * powTerm / (powTerm - 1);
        }
      }

      DateTime paymentDate = DateTime(
        startDate.year,
        startDate.month + month,
        1,
      );

      schedule.add(
        EmiMonthRow(
          monthIndex: month,
          paymentDate: paymentDate,
          openingBalance: openingBalance,
          interestPaid: interestPaid,
          principalPaid: principalFromEmi,
          closingBalance: closingBalance,
          emi: actualEmiPaid,
          prepaymentFlag: isPrepaymentMonth,
          prepaymentAmount: actualPrepayment,
        ),
      );

      totalInterest += interestPaid;
      balance = closingBalance;

      if (balance <= 0) {
        break;
      }
    }

    final totalPayment = p + totalInterest;

    return EmiResult(
      emi: originalEmi,
      totalInterest: totalInterest,
      totalPayment: totalPayment,
      schedule: schedule,
    );
  }
}
