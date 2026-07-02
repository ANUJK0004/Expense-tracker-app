class Expense {
  late final int id;
  late final int amount;
  late final String category;
  late final String description;
  late final String type;
  late final DateTime date;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.type,
    required this.date,
  });
}
