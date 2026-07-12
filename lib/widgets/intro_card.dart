import 'package:exes/models/expense.dart';
import 'package:exes/services/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntroCard extends StatelessWidget {
  const IntroCard({super.key,required this.transactions});

  final List<ExpenseTransaction> transactions;

  Map<String,double> currentBalance() {
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
    Map<String,double> map =  {'balance':balance,'income':income,'expense':expense};
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<SettingsController>().currency;

    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
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
                Text("Good Morning 👋", ),
                Text("Current Balance", ),
                Text("$currency${currentBalance()['balance']?.toStringAsFixed(2)}",),
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
                    Text("Income",),
                    Text("$currency${currentBalance()['income']?.toStringAsFixed(2)}",),
                  ],
                ),
                Column(
                  children: [
                    Text("Expenses",),
                    Text("$currency${currentBalance()['expense']?.toStringAsFixed(2)}",),
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
