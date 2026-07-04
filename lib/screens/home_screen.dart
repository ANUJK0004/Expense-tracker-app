import 'package:exes/widgets/intro_card.dart';
import 'package:exes/widgets/recent_transactions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntroCard(),
        // MonthlySpendingChart(),
        RecentTransactions(),
      ],
    );
  }
}
