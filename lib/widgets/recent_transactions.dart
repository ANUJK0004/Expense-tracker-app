import 'package:exes/models/expense.dart';
import 'package:flutter/material.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key,required this.transactions});
  final List<ExpenseTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(28),
            topLeft: Radius.circular(28),
          ),
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.blue.shade500,
          //     Colors.blue.shade200,
          //     Colors.blue.shade300,
          //     Colors.blue.shade200,
          //     Colors.blue.shade500,
          //   ],
          // ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
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
          ],
        ),
      ),
    );
  }
}
