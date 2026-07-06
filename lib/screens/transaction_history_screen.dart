import 'package:exes/models/expense.dart';
import 'package:flutter/material.dart';

class TransactionsHistory extends StatelessWidget {
  TransactionsHistory({super.key,required this.transactions});

  final List<ExpenseTransaction> transactions;

  final List<String> categories = [
    "🍔 Food",
    "🚕 Transport",
    "🛒 Shopping",
    "🎬 Entertainment",
    "🏥 Health",
    "🎓 Education",
    "💼 Salary",
    "🎁 Gift",
    "📈 Investment",
    "📦 Others"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(title: Text("Transactions History"), centerTitle: true),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (build,index){
                  String selectedCategory = "🍔 Food";
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChoiceChip(
                      label: Text(categories[index]),
                      elevation: 2,
                      side: BorderSide(color: Colors.brown.shade900),
                      backgroundColor: Colors.brown.shade500.withOpacity(0.18),
                      selectedColor: Colors.brown.shade500,
                      selected: selectedCategory == categories[index],
                      onSelected: (value) {
                        selectedCategory = categories[index];
                      },
                    ),
                  );
                },
              ),
            ),
            Divider(color: Colors.brown),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.compare_arrows_sharp,color: transactions[index].type=="Expense"?Colors.red:Colors.green,size: 36,),
                      title: Text(transactions[index].category),
                      subtitle: Text(transactions[index].note),
                      trailing: Text(transactions[index].amount.toString()),
                      minTileHeight: 200,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
