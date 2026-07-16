import 'package:exes/models/expense.dart';
import 'package:exes/widgets/intro_card.dart';
import 'package:exes/widgets/recent_transactions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key,required this.transactions});
  final List<ExpenseTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height:24),
        IntroCard( transactions : transactions),
        SizedBox(height:16),
        RecentTransactions( transactions : transactions),
      ],
    );
  }
}
