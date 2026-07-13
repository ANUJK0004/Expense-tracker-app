import 'package:exes/models/expense.dart';
import 'package:exes/services/settings_controller.dart';
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

    // ignore: unused_local_variable
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
      appBar: AppBar(title: Text("Analytics")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton<TimePeriod>(
              style: ButtonStyle(
                backgroundColor:
                WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context)
                        .colorScheme
                        .primaryContainer;
                  }

                  return Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest;
                }),
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
            child: Card(
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Icon(
                      Icons.analytics_outlined,
                      size: 70,
                      color: Theme.of(context).colorScheme.primary,
                    ),

                    SizedBox(height:20),

                    Text(
                      "No analytics yet",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    SizedBox(height:8),

                    Text(
                      "Add your first transaction to see charts",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
              : Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        margin: const EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                summaryTitle,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),

                              const SizedBox(height: 12),

                              Text(
                                "Expense : ${balance['expense']}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),

                              Text(
                                "Income : ${balance['income']}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),

                              Text(
                                "Saving : ${balance['balance']}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Card(
                                margin: const EdgeInsets.all(16),
                                child: SizedBox(
                                  height: size.width,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Income vs Expense",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
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
                              ),
                              Card(
                                margin: const EdgeInsets.all(16),
                                child: SizedBox(
                                  height: size.width,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Expense Distribution",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
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
                              ),
                              Card(
                                margin: const EdgeInsets.all(16),
                                child: SizedBox(
                                  height: size.width,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Daily Spending Trend",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: LineChart(
                                            LineChartData(
                                              gridData: FlGridData(
                                                show: true,
                                                drawVerticalLine: true,
                                                getDrawingHorizontalLine:
                                                    (value) {
                                                      return FlLine(
                                                        color: Theme.of(
                                                          context,
                                                        ).dividerColor,
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                                getDrawingVerticalLine:
                                                    (value) {
                                                      return FlLine(
                                                        color: Theme.of(
                                                          context,
                                                        ).dividerColor,
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                              ),
                                              borderData: FlBorderData(
                                                border: Border.all(
                                                  color: Theme.of(
                                                    context,
                                                  ).dividerColor,
                                                ),
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
                                                              (a, b) => a.key
                                                                  .compareTo(
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

                                                      return Text(
                                                        day.toString(),
                                                      );
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
                                                  dotData: FlDotData(
                                                    show: true,
                                                  ),
                                                  belowBarData: BarAreaData(
                                                    show: true,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withValues(
                                                          alpha: 0.20,
                                                        ),
                                                  ),
                                                  isStrokeCapRound: true,
                                                  preventCurveOverShooting:
                                                      true,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
