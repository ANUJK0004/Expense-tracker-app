
class ExpenseTransaction {
  final int? id;
  final double amount;
  final String category;
  final String note;
  final String type;
  final DateTime date;

  const ExpenseTransaction({
    this.id,
    required this.amount,
    required this.category,
    required this.note,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'note': note,
      'type': type,
      'date': date.toIso8601String(),
    };
  }

  factory ExpenseTransaction.fromMap(Map<String,dynamic> map){
    return ExpenseTransaction(
      id: map['id'],
      amount: map['amount'].toDouble(),
      category: map['category'],
      note: map['note'],
      type: map['type'],
      date: DateTime.parse(map['date']),
    );
  }

  @override
  String toString() {
    return 'Expense{id: $id, amount: $amount, category: $category, note : $note, type: $type, date: $date}';
  }

}
