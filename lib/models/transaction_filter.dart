class TransactionFilter {
  final String type;
  final String category;
  final double startAmount;
  final double endAmount;
  final DateTime startingDate;
  final DateTime endDate;
  final String sortBy;


  TransactionFilter({
    required this.type,
    required this.category,
    required this.startAmount,
    required this.endAmount,
    required this.startingDate,
    required this.endDate,
    required this.sortBy,
  });
}
