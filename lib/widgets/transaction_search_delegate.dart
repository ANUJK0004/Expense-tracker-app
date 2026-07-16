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

  Widget highlightedText(
    BuildContext context,
    String text, {
    TextStyle? style,
  }) {
    if (query.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    if (!lowerText.contains(lowerQuery)) {
      return Text(
        text,
        style: style,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    final spans = <TextSpan>[];

    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);

      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primaryContainer.withOpacity(.35),
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      start = index + query.length;
    }

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style ?? Theme.of(context).textTheme.bodyMedium,
        children: spans,
      ),
    );
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

          title: highlightedText(
            context,
            transaction.category.split(" ").last,
            style: Theme.of(context).textTheme.titleMedium,
          ),

          subtitle: highlightedText(
            context,
            transaction.note.isEmpty
                ? "No note"
                : transaction.note,
            style: Theme.of(context).textTheme.bodySmall,
          ),

          trailing: highlightedText(
            context,
            "${transaction.type == "Expense" ? "-" : "+"}${transaction.amount}",
            style: TextStyle(
              color: transaction.type == "Expense"
                  ? Colors.red
                  : Colors.green,
              fontWeight: FontWeight.bold,
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

          title: highlightedText(
            context,
            transaction.category.split(" ").last,
            style: Theme.of(context).textTheme.titleMedium,
          ),

          subtitle: highlightedText(
            context,
            transaction.note.isEmpty
                ? "No note"
                : transaction.note,
            style: Theme.of(context).textTheme.bodySmall,
          ),

          trailing: highlightedText(
            context,
            "${transaction.type == "Expense" ? "-" : "+"}${transaction.amount}",
            style: TextStyle(
              color: transaction.type == "Expense"
                  ? Colors.red
                  : Colors.green,
              fontWeight: FontWeight.bold,
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
