enum PrepaymentType { oneTime, recurring }

enum PrepaymentStrategy { reduceEMI, reduceTenure }

enum PrepaymentFrequency {
  every3Months('Every 3 Months', 3),
  every6Months('Every 6 Months', 6),
  every9Months('Every 9 Months', 9),
  everyYear('Every Year', 12);

  const PrepaymentFrequency(this.displayLabel, this.value);

  final String displayLabel;
  final double value;
}

class LoanInput {
  double principal;
  double annualInterestRate;
  int tenureYears;
  int get tenureMonths => tenureYears * 12;
  double get monthlyRate => annualInterestRate / 12 / 100;
  bool enablePrepayment;
  PrepaymentType? prepaymentType;
  PrepaymentStrategy? prepaymentStrategy;
  double? prepaymentAmount;
  int? prepaymentMonth;
  double? prepaymentFrequency;
  DateTime startDate;

  LoanInput({
    required this.principal,
    required this.annualInterestRate,
    required this.tenureYears,
    required this.startDate,
    required this.enablePrepayment,
    this.prepaymentType,
    this.prepaymentStrategy,
    this.prepaymentAmount,
    this.prepaymentMonth,
    this.prepaymentFrequency,
  });
}

class EmiResult {
  double emi;
  double totalInterest;
  double totalPayment;
  List<EmiMonthRow> schedule = [];

  EmiResult({
    required this.emi,
    required this.totalInterest,
    required this.totalPayment,
    required this.schedule,
  });
}

class EmiMonthRow {
  int monthIndex;
  double openingBalance;
  double interestPaid;
  double principalPaid;
  double closingBalance;
  final double emi;
  DateTime paymentDate;
  bool prepaymentFlag;
  double prepaymentAmount;

  EmiMonthRow({
    required this.monthIndex,
    required this.openingBalance,
    required this.interestPaid,
    required this.principalPaid,
    required this.closingBalance,
    required this.emi,
    required this.paymentDate,
    required this.prepaymentFlag,
    required this.prepaymentAmount,
  });
}

class YearSummary {
  final int year;
  final double totalEmi;
  final double totalInterest;
  final double totalPaid;
  final List<EmiMonthRow> rows;

  YearSummary({
    required this.year,
    required this.totalEmi,
    required this.totalInterest,
    required this.totalPaid,
    required this.rows,
  });
}

class LoanState {
  final LoanInput loanInput;
  final EmiResult result;
  final List<YearSummary> summaries;

  LoanState({
    required this.loanInput,
    required this.result,
    required this.summaries,
  });
}
