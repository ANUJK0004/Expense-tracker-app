import 'package:exes/models/expense.dart';
import 'package:exes/services/settings_controller.dart';
import 'package:exes/utils/text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key, required this.transactions});
  final List<ExpenseTransaction> transactions;

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

enum TimePeriod { daily, weekly, monthly, yearly }

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late TimePeriod selectedTimePeriod;

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

  Map<String, double> get categoryTotals {
    final totals = <String, double>{};

    for (final t in filteredTransactions) {
      if (t.type != "Expense") continue;
      totals[t.category] = (totals[t.category] ?? 0) + t.amount;
    }
    return totals;
  }

  Map<DateTime, double> get dailyTotals {
    final totals = <DateTime, double>{};
    for (final t in filteredTransactions) {
      final date = DateTime(t.date.year, t.date.month, t.date.day);
      totals[date] = (totals[date] ?? 0) + t.amount;
    }
    return totals;
  }

  List<PieChartSectionData> getPieChartSections() {
    Map<String, Color> colors = {
      "Food": Colors.orange,
      "Transport": Colors.blue,
      "Shopping": Colors.purple,
      "Entertainment": Colors.pink,
      "Health": Colors.red,
      "Education": Colors.teal,
      "Salary": Colors.green,
      "Gifts": Colors.brown,
      "Investments": Colors.indigo,
      "Other": Colors.amber,
    };

    int index = 0;

    return categoryTotals.entries.map((entry) {
      final section = PieChartSectionData(
        value: entry.value,
        title: entry.key.split(" ").last,
        radius: 70,
        color: colors[entry.key.split(" ").last],
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
      index++;
      return section;
    }).toList();
  }

  List<FlSpot> getLineSpots() {
    final entries = dailyTotals.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return List.generate(entries.length, (index) {
      return FlSpot((index.toDouble()), entries[index].value);
    });
  }

  String get summaryTitle {
    switch (selectedTimePeriod) {
      case TimePeriod.daily:
        return "Today";

      case TimePeriod.weekly:
        return "Last 7 Days";

      case TimePeriod.monthly:
        return "Last 30 Days";

      case TimePeriod.yearly:
        return "Last Year";
    }
  }

  @override
  void initState() {
    super.initState();

    final filter = context.read<SettingsController>().analyticsFilter;

    switch (filter) {
      case "Daily":
        selectedTimePeriod = TimePeriod.daily;

        break;

      case "Weekly":
        selectedTimePeriod = TimePeriod.weekly;

        break;

      case "Monthly":
        selectedTimePeriod = TimePeriod.monthly;

        break;

      case "Yearly":
        selectedTimePeriod = TimePeriod.yearly;

        break;

      default:
        selectedTimePeriod = TimePeriod.monthly;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final balance = currentBalance();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text("Analytics"), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton<TimePeriod>(
              style: SegmentedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                selectedBackgroundColor: Theme.of(context).shadowColor,
                foregroundColor: Theme.of(context).shadowColor,
                selectedForegroundColor: Theme.of(context).primaryColor,
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
          filteredTransactions.isEmpty
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("📊", style: textStyle),
                      Text("No analytics yet", style: textStyle),
                      Text(
                        "Add your first transaction to see charts",
                        style: textStyle,
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(summaryTitle),
                                Text(
                                  "Expense : ${balance['expense']}",
                                  style: textStyle,
                                ),
                                Text(
                                  "Income : ${balance['income']}",
                                  style: textStyle,
                                ),
                                Text(
                                  "Saving : ${balance['balance']}",
                                  style: textStyle,
                                ),
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
                                height: size.width,
                                width: size.width,
                                margin: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).shadowColor,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text("Income vs Expense", style: textStyle),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: BarChart(
                                          BarChartData(
                                            alignment:
                                                BarChartAlignment.spaceAround,
                                            borderData: FlBorderData(
                                              show: false,
                                            ),
                                            gridData: FlGridData(show: true),
                                            titlesData: FlTitlesData(
                                              topTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: false,
                                                ),
                                              ),
                                              rightTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: false,
                                                ),
                                              ),
                                              leftTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                ),
                                              ),
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  getTitlesWidget: (value, meta) {
                                                    switch (value.toInt()) {
                                                      case 0:
                                                        return const Text(
                                                          "Expense",
                                                        );
                                                      case 1:
                                                        return const Text(
                                                          "Income",
                                                        );
                                                      default:
                                                        return const SizedBox();
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            barGroups: [
                                              BarChartGroupData(
                                                x: 0,
                                                barRods: [
                                                  BarChartRodData(
                                                    toY: balance['expense']!,
                                                    width: 20,
                                                    color: Colors.red,
                                                  ),
                                                ],
                                              ),
                                              BarChartGroupData(
                                                x: 1,
                                                barRods: [
                                                  BarChartRodData(
                                                    toY: balance['income']!,
                                                    width: 20,
                                                    color: Colors.green,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: size.width,
                                width: size.width,
                                margin: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).shadowColor,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Expense Distribution",
                                      style: textStyle,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: PieChart(
                                          PieChartData(
                                            centerSpaceRadius: 70,
                                            sectionsSpace: 3,
                                            sections: getPieChartSections(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: size.width * 0.75,
                                width: size.width,
                                margin: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).shadowColor,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Daily Spending Trend",
                                      style: textStyle,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: LineChart(
                                          LineChartData(
                                            gridData: FlGridData(show: true),
                                            borderData: FlBorderData(
                                              show: true,
                                            ),
                                            titlesData: FlTitlesData(
                                              leftTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                ),
                                              ),
                                              rightTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: false,
                                                ),
                                              ),
                                              topTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: false,
                                                ),
                                              ),
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  getTitlesWidget: (value, meta) {
                                                    final entries =
                                                        dailyTotals.entries
                                                            .toList()
                                                          ..sort(
                                                            (a, b) =>
                                                                a.key.compareTo(
                                                                  b.key,
                                                                ),
                                                          );

                                                    if (value.toInt() >=
                                                        entries.length) {
                                                      return const SizedBox();
                                                    }

                                                    final day =
                                                        entries[value.toInt()]
                                                            .key
                                                            .day;

                                                    return Text(day.toString());
                                                  },
                                                ),
                                              ),
                                            ),
                                            lineBarsData: [
                                              LineChartBarData(
                                                spots: getLineSpots(),
                                                isCurved: true,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                barWidth: 4,
                                                dotData: FlDotData(show: true),
                                                belowBarData: BarAreaData(
                                                  show: true,
                                                  color: Colors.brown
                                                      .withOpacity(0.2),
                                                ),
                                                isStrokeCapRound: true,
                                                preventCurveOverShooting: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
