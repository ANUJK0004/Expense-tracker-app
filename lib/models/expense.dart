class Expense {
  final int? id;
  final double amount;
  final String category;
  final String description;
  final String type;
  final DateTime date;

  Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.type,
    required this.date,
  });
}
