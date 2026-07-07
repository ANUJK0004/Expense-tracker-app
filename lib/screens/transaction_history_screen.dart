import 'package:exes/database/database_helper.dart';
import 'package:exes/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsHistory extends StatefulWidget {
  const TransactionsHistory({super.key, required this.transactions});

  final List<ExpenseTransaction> transactions;

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
  late List<ExpenseTransaction> filteredTransactions = widget.transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        title: Column(
          children: [
            Text("Transactions History"),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search_outlined),
                  color: Colors.brown,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.filter_alt_outlined),
                  color: Colors.brown,
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: widget.transactions.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("📭"),
                        Text("No transactions found"),
                        Text("Add some transactions to see them here"),
                      ],
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (build, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ChoiceChip(
                            label: Text(categories[index]),
                            elevation: 2,
                            side: BorderSide(color: Colors.brown.shade900),
                            backgroundColor: Colors.brown.shade500.withOpacity(
                              0.18,
                            ),
                            selectedColor: Colors.brown.shade200,
                            selected: selectedCategory == categories[index],
                            onSelected: (value) {
                              setState(() {
                                selectedCategory = categories[index];
                                if (selectedCategory == "All") {
                                  filteredTransactions = widget.transactions;
                                } else {
                                  filteredTransactions = widget.transactions
                                      .where(
                                        (e) => e.category == selectedCategory,
                                      )
                                      .toList();
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
            Divider(color: Colors.brown),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: filteredTransactions.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Dismissible(
                        key: ValueKey(filteredTransactions[index]),
                        secondaryBackground: Container(
                          color: Colors.green,
                          child: Icon(Icons.edit_outlined),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            if(direction == DismissDirection.endToStart){

                            }
                            else{
                              filteredTransactions.removeAt(index);
                              DatabaseHelper.instance.deleteTransaction(filteredTransactions[index].id!);
                            }
                          });
                        },
                        background: Container(
                          color: Colors.red,
                          child: Icon(Icons.delete_outline),
                        ),
                        child: ListTile(
                          // leading: Icon(
                          //   Icons.compare_arrows_sharp,
                          //   color: filteredTransactions[index].type == "Expense"
                          //       ? Colors.red
                          //       : Colors.green,
                          //   size: 36,
                          // ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Text(
                              filteredTransactions[index].category[0]
                            ),
                          ),
                          title: Text(filteredTransactions[index].category),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(filteredTransactions[index].note),
                              Text(
                                DateFormat.yMMMMd()
                                    .format(filteredTransactions[index].date)
                                    .toString(),
                              ),
                            ],
                          ),
                          trailing: Text(
                            filteredTransactions[index].type == "Expense"
                                ? "- ${filteredTransactions[index].amount}"
                                : "+ ${filteredTransactions[index].amount}",
                            style: TextStyle(
                              color: filteredTransactions[index].type == "Expense"
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ),
                      Divider(color: Colors.brown),
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
