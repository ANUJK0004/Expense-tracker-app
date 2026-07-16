import 'package:exes/models/expense.dart';
import 'package:flutter/material.dart';

class TransactionSearchDelegate extends SearchDelegate<ExpenseTransaction?> {
  final List<ExpenseTransaction> transactions;

  TransactionSearchDelegate({required this.transactions});

  @override
  String get searchFieldLabel => "Search transactions";

  @override
  TextStyle? get searchFieldStyle => const TextStyle(fontSize: 16);

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = "";
          },
        ),
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = transactions.where((transaction) {
      final text = query.toLowerCase();

      return transaction.category.toLowerCase().contains(text) ||
          transaction.note.toLowerCase().contains(text) ||
          transaction.amount.toString().contains(text);
    }).toList();

    if (query.isEmpty) {
      return const Center(child: Text("Search by category, note or amount"));
    }

    if (suggestions.isEmpty) {
      return const Center(child: Text("No matching transaction"));
    }

    return ListView.builder(
      itemCount: suggestions.length,

      itemBuilder: (_, index) {
        final transaction = suggestions[index];

        return ListTile(
          leading: CircleAvatar(
            child: Text(transaction.category.split(" ").first),
          ),

          title: Text(transaction.category.split(" ").last),

          subtitle: Text(
            transaction.note.isEmpty ? "No note" : transaction.note,
          ),

          trailing: Text(
            transaction.type == "Expense"
                ? "-${transaction.amount}"
                : "+${transaction.amount}",
            style: TextStyle(
              color: transaction.type == "Expense" ? Colors.red : Colors.green,
            ),
          ),

          onTap: () {
            close(context, transaction);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = transactions.where((transaction) {
      final text = query.toLowerCase();

      return transaction.category.toLowerCase().contains(text) ||
          transaction.note.toLowerCase().contains(text) ||
          transaction.amount.toString().contains(text);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No transactions found"));
    }

    return ListView.builder(
      itemCount: results.length,

      itemBuilder: (_, index) {
        final transaction = results[index];

        return ListTile(
          leading: CircleAvatar(
            child: Text(transaction.category.split(" ").first),
          ),

          title: Text(transaction.category.split(" ").last),

          subtitle: Text(
            transaction.note.isEmpty ? "No note" : transaction.note,
          ),

          trailing: Text(
            transaction.type == "Expense"
                ? "-${transaction.amount}"
                : "+${transaction.amount}",
            style: TextStyle(
              color: transaction.type == "Expense" ? Colors.red : Colors.green,
            ),
          ),

          onTap: () {
            close(context, transaction);
          },
        );
      },
    );
  }
}
