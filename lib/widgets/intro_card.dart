import 'package:exes/models/expense.dart';
import 'package:exes/services/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntroCard extends StatelessWidget {
  const IntroCard({super.key, required this.transactions});

  final List<ExpenseTransaction> transactions;

  Map<String, double> currentBalance() {
    double income = 0;
    double expense = 0;

    for (final transaction in transactions) {
      if (transaction.type == "Income") {
        income += transaction.amount;
      } else {
        expense += transaction.amount;
      }
    }

    return {"balance": income - expense, "income": income, "expense": expense};
  }

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<SettingsController>().currency;

    final scheme = Theme.of(context).colorScheme;

    final balance = currentBalance();

    return Container(
      height: MediaQuery.of(context).size.height * .33,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                "Good Morning 👋",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: scheme.onPrimary),
              ),

              const SizedBox(height: 8),

              Text(
                "Current Balance",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: scheme.onPrimary.withOpacity(.8),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "$currency${balance["balance"]!.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Icon(Icons.arrow_downward, color: Colors.green.shade300),

                  const SizedBox(height: 6),

                  Text("Income", style: TextStyle(color: scheme.onPrimary)),

                  Text(
                    "$currency${balance["income"]!.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  Icon(Icons.arrow_upward, color: Colors.red.shade300),

                  const SizedBox(height: 6),

                  Text("Expense", style: TextStyle(color: scheme.onPrimary)),

                  Text(
                    "$currency${balance["expense"]!.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
