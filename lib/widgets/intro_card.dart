import 'package:exes/models/expense.dart';
import 'package:exes/utils/text_styles.dart';
import 'package:flutter/material.dart';

class IntroCard extends StatelessWidget {
  const IntroCard({super.key,required this.transactions});

  final List<ExpenseTransaction> transactions;

  double currentBalance() {
    double income = 0;
    double expense = 0;

    for(final transaction in transactions){

      if(transaction.type == "Income"){
        income += transaction.amount;
      }else{
        expense += transaction.amount;
      }
    }

    final balance = income - expense;
    return balance;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade500,
            Colors.blue.shade200,
            Colors.blue.shade300,
            Colors.blue.shade200,
            Colors.blue.shade500,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Good Morning 👋", style: textStyle),
                Text("Current Balance", style: textStyle),
                Text("₹${currentBalance().toStringAsFixed(2)}", style: textStyle),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("Income", style: textStyle),
                    Text("₹52,480", style: textStyle),
                  ],
                ),
                Column(
                  children: [
                    Text("Expenses", style: textStyle),
                    Text("22,520", style: textStyle),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
