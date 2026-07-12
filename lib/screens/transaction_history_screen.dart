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
  });

  final List<ExpenseTransaction> transactions;
  final Future<void> Function(ExpenseTransaction transaction) onDelete;
  final void Function(ExpenseTransaction transaction) onTap;

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
            onPressed: () {},
            icon: Icon(Icons.search_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_alt_outlined),
          ),
        ],
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: widget.transactions.isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("📭",),
                  Text("No transactions found",),
                  Text("Add some transactions to see them here", ),
                ],
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
                            elevation: 2,
                            selected: selectedCategory == categories[index],
                            onSelected: (value) {
                              setState(() {
                                selectedCategory = categories[index];
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          Divider(),
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
                                color: Colors.red,
                                child: Icon(Icons.delete_outline),
                              ),
                              child: ListTile(
                                onTap: () {
                                  widget.onTap(transaction);
                                },
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Text(
                                    transaction.category.split(" ").first,
                                  ),
                                ),
                                title: Text(transaction.category.split(" ").last,),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      transaction.note.isEmpty
                                          ? "No note"
                                          : transaction.note,
                                    ),
                                    Text(
                                      DateFormat(
                                        settings.dateFormat,
                                      ).format(transaction.date),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  transaction.type == "Expense"
                                      ? "- ${transaction.amount}"
                                      : "+ ${transaction.amount}",
                                  style: TextStyle(
                                    color: transaction.type == "Expense"
                                        ? Colors.red
                                        : Colors.green,
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
