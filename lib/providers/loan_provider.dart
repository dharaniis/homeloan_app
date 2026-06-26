import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeloan_calc_app/logic/emi_calculator.dart';
import 'package:homeloan_calc_app/models/emi_models.dart';
import 'package:flutter/material.dart';

final loanControllerProvider = NotifierProvider<LoanController, LoanState>(() {
  return LoanController();
});

class LoanController extends Notifier<LoanState> {
  @override
  LoanState build() {
    final initialInput = LoanInput(
      principal: 100000,
      annualInterestRate: 7.0,
      tenureYears: 1,
      startDate: DateTime.now(),
      enablePrepayment: false,
      prepaymentType: PrepaymentType.oneTime,
      prepaymentAmount: 5000,
      prepaymentMonth: 1,
      prepaymentStrategy: PrepaymentStrategy.reduceTenure,
      prepaymentFrequency: 6,
    );

    return _calculateState(initialInput);
  }

  LoanState _calculateState(LoanInput input) {
    final result = EmiCalculator().calculate(input);
    final summaries = _buildYearSummaries(result.schedule);
    return LoanState(
      loanInput: input,
      result: result,
      summaries: summaries,
    );
  }

  List<YearSummary> _buildYearSummaries(List<EmiMonthRow> schedule) {
    final Map<int, List<EmiMonthRow>> byYear = {};

    for (final row in schedule) {
      final year = row.paymentDate.year;
      byYear.putIfAbsent(year, () => []);
      byYear[year]!.add(row);
    }

    final List<YearSummary> summaries = [];

    final sortedYears = byYear.keys.toList()..sort();
    for (final year in sortedYears) {
      final rows = byYear[year]!;

      double totalEmi = 0;
      double totalInterest = 0;
      double totalPaid = 0;

      for (final row in rows) {
        totalEmi += row.emi;
        totalInterest += row.interestPaid;
        totalPaid += row.emi + (row.prepaymentFlag ? row.prepaymentAmount : 0);
      }

      summaries.add(
        YearSummary(
          year: year,
          totalEmi: totalEmi,
          totalInterest: totalInterest,
          totalPaid: totalPaid,
          rows: rows,
        ),
      );
    }

    return summaries;
  }

  void updatePrincipal(double value) {
    final newInput = state.loanInput;
    newInput.principal = value;
    state = _calculateState(newInput);
  }

  void updateTenure(int value) {
    final newInput = state.loanInput;
    newInput.tenureYears = value;
    
    int maxMonths = newInput.tenureMonths;
    if (newInput.prepaymentMonth != null && newInput.prepaymentMonth! > maxMonths) {
      newInput.prepaymentMonth = maxMonths;
    }
    
    state = _calculateState(newInput);
  }

  void updateRate(double value) {
    final newInput = state.loanInput;
    newInput.annualInterestRate = value;
    state = _calculateState(newInput);
  }

  void updateStartDate(DateTime value) {
    final newInput = state.loanInput;
    
    final oldPrepDate = DateTime(
      newInput.startDate.year,
      newInput.startDate.month + (newInput.prepaymentMonth ?? 1) - 1,
    );
    
    newInput.startDate = value;
    
    int newMonthIndex = DateUtils.monthDelta(newInput.startDate, oldPrepDate) + 1;
    if (newMonthIndex < 1) {
      newMonthIndex = 1;
    }
    int maxMonths = newInput.tenureMonths;
    if (newMonthIndex > maxMonths) {
      newMonthIndex = maxMonths;
    }
    newInput.prepaymentMonth = newMonthIndex;

    state = _calculateState(newInput);
  }

  void togglePrepayment(bool value) {
    final newInput = state.loanInput;
    newInput.enablePrepayment = value;
    state = _calculateState(newInput);
  }

  void updatePrepaymentType(PrepaymentType value) {
    final newInput = state.loanInput;
    newInput.prepaymentType = value;
    state = _calculateState(newInput);
  }

  void updatePrepaymentStrategy(PrepaymentStrategy value) {
    final newInput = state.loanInput;
    newInput.prepaymentStrategy = value;
    state = _calculateState(newInput);
  }

  void updatePrepaymentAmount(double value) {
    final newInput = state.loanInput;
    newInput.prepaymentAmount = value;
    state = _calculateState(newInput);
  }

  void updatePrepaymentMonth(int value) {
    final newInput = state.loanInput;
    newInput.prepaymentMonth = value;
    state = _calculateState(newInput);
  }

  void updatePrepaymentFrequency(double value) {
    final newInput = state.loanInput;
    newInput.prepaymentFrequency = value;
    state = _calculateState(newInput);
  }
}
