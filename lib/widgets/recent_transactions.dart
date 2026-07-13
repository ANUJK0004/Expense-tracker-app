import 'package:exes/models/expense.dart';
import 'package:exes/services/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key, required this.transactions});

  final List<ExpenseTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<SettingsController>().currency;

    // final scheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,

          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),

          boxShadow: [
            BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 8),
          ],
        ),

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Recent Transactions",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            Expanded(
              child: transactions.isEmpty
                  ? Center(
                      child: Text(
                        "No transactions yet",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];

                        final isExpense = transaction.type == "Expense";

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isExpense
                                ? Colors.red.shade100
                                : Colors.green.shade100,

                            child: Icon(
                              isExpense
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: isExpense ? Colors.red : Colors.green,
                            ),
                          ),

                          title: Text(
                            transaction.category,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),

                          subtitle: Text(
                            transaction.note.isEmpty
                                ? "No Note"
                                : transaction.note,
                          ),

                          trailing: Text(
                            "$currency${transaction.amount.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: isExpense ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
