class AdministrativeExpenses {
  // Constructor for initializing each expense category
  AdministrativeExpenses({
    required this.rent,
    required this.depreciation,
    required this.salesExpense,
    required this.payroll,
    required this.stationery,
    required this.utilities,
    double? total,
  }) : total = total ?? 0;

  // Instance variables to store each category of administrative expenses
  final double payroll;
  final double depreciation;
  final double rent;
  final double salesExpense;
  final double stationery;
  final double utilities;
  final double total;
}
