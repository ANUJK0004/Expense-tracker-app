class TransactionFilter {
  final String type;
  final String category;
  final double startAmount;
  final double endAmount;
  final DateTime? startDate;
  final DateTime? endDate;
  final String sortBy;

  TransactionFilter({
    required this.type,
    required this.category,
    required this.startAmount,
    required this.endAmount,
    this.startDate,
    this.endDate,
    required this.sortBy,
  });

  factory TransactionFilter.empty() {
    return TransactionFilter(
      type: "All",
      category: "All",
      startAmount: 0,
      endAmount: double.infinity,
      startDate: null,
      endDate: null,
      sortBy: "Date (Newest First)",
    );
  }

  bool get hasFilters {
    return type != "All" ||
        category != "All" ||
        startAmount != 0 ||
        endAmount != double.infinity ||
        startDate != null ||
        endDate != null;
  }

  int get activeFilterCount {
    int count = 0;

    if (type != "All") count++;
    if (category != "All") count++;
    if (startAmount != 0 || endAmount != double.infinity) {
      count++;
    }
    if (startDate != null || endDate != null) {
      count++;
    }
    return count;
  }

  TransactionFilter copyWith({
    String? type,
    String? category,
    double? startAmount,
    double? endAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
  }) {
    return TransactionFilter(
      type: type ?? this.type,
      category: category ?? this.category,
      startAmount: startAmount ?? this.startAmount,
      endAmount: endAmount ?? this.endAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  String toString() {
    return '''
TransactionFilter(
type: $type,
category: $category,
amount: $startAmount - $endAmount,
startDate: $startDate,
endDate: $endDate,
sortBy: $sortBy,
)
''';
  }
}
