import 'package:exes/database/database_helper.dart';
import 'package:exes/models/expense.dart';
import 'package:exes/screens/analytics_screen.dart';
import 'package:exes/screens/transaction_history_screen.dart';
import 'package:exes/screens/home_screen.dart';
import 'package:exes/screens/settings_screen.dart';
import 'package:exes/widgets/expense_bottom_sheet.dart';
import 'package:exes/widgets/floating_action_button.dart';
import 'package:exes/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentIndex = 0;


  List<ExpenseTransaction> transactions = [];

  Future<void> loadTransactions() async {

    transactions = await DatabaseHelper.instance.getAllTransactions();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> openBottomSheet() async {
    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ExpenseBottomSheet(),
    );

    if (added == true) {
      await loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      bottomNavigationBar: ScreensNavigationBar(
        changedIndex: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
      ),
      body: [
        HomeScreen(
          transactions: transactions,
        ),
        AnalyticsScreen(
          transactions: transactions,
        ),
        TransactionsHistory(
          transactions: transactions,
        ),
        SettingsScreen(),
      ][currentIndex],
      floatingActionButton: AddExpenseButton(onPressed: openBottomSheet),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
