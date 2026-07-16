  import 'package:exes/database/database_helper.dart';
  import 'package:exes/models/expense.dart';
  import 'package:exes/screens/analytics_screen.dart';
  import 'package:exes/screens/transaction_history_screen.dart';
  import 'package:exes/screens/home_screen.dart';
  import 'package:exes/screens/settings_screen.dart';
  import 'package:exes/services/import_export_service.dart';
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
    final importExport = ImportExportService.instance;

    Future<void> loadTransactions() async {
      final data =
      await DatabaseHelper.instance.getAllTransactions();

      if (!mounted) return;

      setState(() {
        transactions = data;
      });
    }

    Future<void> openExpenseBottomSheet() async {
      final added = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ExpenseBottomSheet(onAdd: insertTransaction),
      );

      if (added == true) {
        await loadTransactions();
      }
    }


    Future<void> insertTransaction(ExpenseTransaction transaction) async {
      await DatabaseHelper.instance.insertTransaction(transaction);
    }

    Future<void> deleteTransaction(ExpenseTransaction transaction) async {
      await DatabaseHelper.instance.deleteTransaction(transaction.id!);
      await loadTransactions();
    }

    Future<void> editTransaction(ExpenseTransaction transaction) async {

      final updated = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (_) => ExpenseBottomSheet(transaction: transaction,onUpdate: updateTransaction,),
      );

      if (updated == true) {
        await loadTransactions();
      }
    }

    Future<void> updateTransaction(ExpenseTransaction transaction) async {
      await DatabaseHelper.instance.updateTransaction(transaction);
    }

    Future<void> clearAllTransactions() async {
      await DatabaseHelper.instance.clearAllTransactions();
      await loadTransactions();
    }

    Future<void> exportJson() async {
      await importExport.exportJson();
    }

    Future<void> exportCSV() async {
      await importExport.exportCSV();
    }

    Future<void> importJson() async {
      await importExport.importJson();

      await loadTransactions();
    }

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadTransactions();
      });
    }

    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          bottomNavigationBar: ScreensNavigationBar(
            changedIndex: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            currentIndex: currentIndex,
          ),
          body: IndexedStack(
            index: currentIndex,
            children: [
              HomeScreen(transactions: transactions),
              AnalyticsScreen(transactions: transactions),
              TransactionsHistory(
                transactions: transactions,
                onDelete: deleteTransaction,
                onTap : editTransaction,
              ),
              SettingsScreen(
                onClearAll: clearAllTransactions,
                onExportCSV: exportCSV,
                onExportJson: exportJson,
                onImportJson: importJson,
              ),
            ],
          ),
          floatingActionButton: currentIndex == 0?AddExpenseButton(onPressed: openExpenseBottomSheet) : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        ),
      );
    }
  }
