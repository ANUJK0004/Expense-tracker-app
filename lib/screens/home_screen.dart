import 'package:exes/models/expense.dart';
import 'package:exes/widgets/intro_card.dart';
import 'package:exes/widgets/recent_transactions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key,required this.transactions});
  final List<ExpenseTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntroCard( transactions : transactions),
          SizedBox(height:16),
          RecentTransactions( transactions : transactions),
        ],
      ),
    );
  }
}
