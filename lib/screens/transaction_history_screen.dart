import 'package:exes/database/database_helper.dart';
import 'package:exes/models/expense.dart';
import 'package:exes/models/transaction_filter.dart';
import 'package:exes/services/settings_controller.dart';
import 'package:exes/widgets/filter_bottom_sheet.dart';
import 'package:exes/widgets/transaction_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionsHistory extends StatefulWidget {
  const TransactionsHistory({
    super.key,
    required this.transactions,
    required this.onDelete,
    required this.onTap,
  });

  final List<ExpenseTransaction> transactions;
  final Future<void> Function(ExpenseTransaction transaction) onDelete;
  final void Function(ExpenseTransaction transaction) onTap;

  @override
  State<TransactionsHistory> createState() => _TransactionsHistoryState();
}

String selectedCategory = "All";

class _TransactionsHistoryState extends State<TransactionsHistory> {
  late List<ExpenseTransaction> displayedTransactions;
  TransactionFilter? currentFilter = TransactionFilter.empty();

  Future<void> openFilterBottomSheet() async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(onFilter: applyFilters),
    );
  }

  Future<void> applyFilters(TransactionFilter filter) async {
    currentFilter = filter;
    final result = await DatabaseHelper.instance.getFilteredTransactions(
      filter,
    );
    if (!mounted) return;
    setState(() {
      displayedTransactions = result;
    });
  }

  @override
  void initState() {
    super.initState();
    displayedTransactions = List.from(widget.transactions);
  }

  @override
  void didUpdateWidget(covariant TransactionsHistory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transactions != widget.transactions) {
      displayedTransactions = List.from(widget.transactions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions History"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () async {
              final result = await showSearch<ExpenseTransaction?>(
                context: context,

                delegate: TransactionSearchDelegate(
                  transactions: displayedTransactions,
                ),
              );

              if (result == null) return;

              widget.onTap(result);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.filter_alt_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () async {
              await openFilterBottomSheet();
            },
          ),
        ],
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: displayedTransactions.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 80,
                      color: Theme.of(context).colorScheme.outline,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      "No Transactions",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Tap + to add your first transaction",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          Divider(indent: 16, endIndent: 16),
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: displayedTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = displayedTransactions[index];
                        return Column(
                          children: [
                            Dismissible(
                              key: ValueKey(transaction.id),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async {
                                await widget.onDelete(transaction);
                              },
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 24),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.errorContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onErrorContainer,
                                ),
                              ),
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                child: ListTile(
                                  onTap: () {
                                    widget.onTap(transaction);
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    child: Text(
                                      transaction.category.split(" ").first,
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    transaction.category.split(" ").last,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        transaction.note.isEmpty
                                            ? "No note"
                                            : transaction.note,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                      Text(
                                        DateFormat(
                                          settings.dateFormat,
                                        ).format(transaction.date),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    "${transaction.type == "Expense" ? "-" : "+"}"
                                    "${settings.currency}"
                                    "${transaction.amount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: transaction.type == "Expense"
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
