import 'package:exes/models/expense.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key, required this.transactions});
  final List<ExpenseTransaction> transactions;

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

enum TimePeriod { daily, weekly, monthly, yearly }

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  TimePeriod selectedTimePeriod = TimePeriod.daily;

  List<ExpenseTransaction> get filteredTransactions {
    final now = DateTime.now();
    switch (selectedTimePeriod) {
      case TimePeriod.daily:
        return widget.transactions
            .where(
              (transaction) =>
                  transaction.date.day == now.day &&
                  transaction.date.month == now.month &&
                  transaction.date.year == now.year,
            )
            .toList();
      case TimePeriod.weekly:
        return widget.transactions
            .where(
              (transaction) =>
                  transaction.date.isAfter(now.subtract(Duration(days: 7))),
            )
            .toList();
      case TimePeriod.monthly:
        return widget.transactions
            .where(
              (transaction) =>
                  transaction.date.isAfter(now.subtract(Duration(days: 30))),
            )
            .toList();
      case TimePeriod.yearly:
        return widget.transactions
            .where(
              (transaction) =>
                  transaction.date.isAfter(now.subtract(Duration(days: 365))),
            )
            .toList();
    }
  }

  Map<String, double> currentBalance() {
    double income = 0;
    double expense = 0;

    for (final transaction in filteredTransactions) {
      if (transaction.type == "Income") {
        income += transaction.amount;
      } else {
        expense += transaction.amount;
      }
    }
    final balance = income - expense;
    Map<String, double> map = {
      'balance': balance,
      'income': income,
      'expense': expense,
    };
    return map;
  }

  Map<String, double> categoryTotals = {};
  void calculateCategoryTotals() {
    for (final t in filteredTransactions) {
      if (t.type != "Expense") continue;
      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
    }
  }

  Map<DateTime,double> dailyTotals = {};
  void calculateDailyTotals(){
    for(final t in filteredTransactions){
      final date = t.date;
      dailyTotals[date] = (dailyTotals[date] ?? 0) + t.amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(title: Text("Analytics"), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton<TimePeriod>(
              style: SegmentedButton.styleFrom(
                backgroundColor: Colors.brown.shade500,
                selectedBackgroundColor: Colors.brown.shade200,
                foregroundColor: Colors.brown.shade200,
                selectedForegroundColor: Colors.brown.shade500,
              ),
              selected: <TimePeriod>{selectedTimePeriod},
              onSelectionChanged: (Set<TimePeriod> newSelection) {
                setState(() {
                  selectedTimePeriod = newSelection.first;
                });
              },
              segments: [
                ButtonSegment(value: TimePeriod.daily, label: Text("Daily")),
                ButtonSegment(value: TimePeriod.weekly, label: Text("Weekly")),
                ButtonSegment(
                  value: TimePeriod.monthly,
                  label: Text("Monthly"),
                ),
                ButtonSegment(value: TimePeriod.yearly, label: Text("Yearly")),
              ],
              multiSelectionEnabled: false,
              emptySelectionAllowed: true,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("This Month"),
                    Text("Expense : ${currentBalance()['expense']}"),
                    Text("Income : ${currentBalance()['income']}"),
                    Text("Saving : ${currentBalance()['balance']}"),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.brown.shade50,
                    ),
                    child: Column(children: [Text("Expense VS Income")]),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.brown.shade50,
                    ),
                    child: Column(children: [Text("Expenses by category")]),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.75,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.brown.shade50,
                    ),
                    child: Column(children: [Text("Top Spending Categories")]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
