import 'package:exes/models/expense.dart';
import 'package:exes/services/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionsHistory extends StatefulWidget {
  const TransactionsHistory({
    super.key,
    required this.transactions,
    required this.onDelete,
    required this.onTap,
    required this.onFilter,
  });

  final List<ExpenseTransaction> transactions;
  final Future<void> Function(ExpenseTransaction transaction) onDelete;
  final void Function(ExpenseTransaction transaction) onTap;
  final VoidCallback onFilter;

  @override
  State<TransactionsHistory> createState() => _TransactionsHistoryState();
}

class _TransactionsHistoryState extends State<TransactionsHistory> {
  String selectedCategory = "All";
  final List<String> categories = [
    "All",
    "🍔 Food",
    "🚕 Transport",
    "🛒 Shopping",
    "🎬 Entertainment",
    "🏥 Health",
    "🎓 Education",
    "💼 Salary",
    "🎁 Gift",
    "📈 Investment",
    "📦 Others",
  ];

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final filteredTransactions = selectedCategory == "All"
        ? widget.transactions
        : widget.transactions
              .where((transaction) => transaction.category == selectedCategory)
              .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions History"),
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          IconButton(
            onPressed: () {
              widget.onFilter();
            },
            icon: Icon(
              Icons.filter_alt_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: widget.transactions.isEmpty
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
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (build, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ChoiceChip(
                            label: Text(categories[index]),
                            selected: selectedCategory == categories[index],
                            onSelected: (_) {
                              setState(() {
                                selectedCategory = categories[index];
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          Divider(indent: 16, endIndent: 16),
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
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
