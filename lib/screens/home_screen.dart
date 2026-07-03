import 'package:exes/widgets/intro_card.dart';
import 'package:exes/widgets/navigation_bar.dart';
import 'package:exes/widgets/recent_transactions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      // appBar: AppBar(
      //   title: Text('Exes'),
      //   centerTitle: true,
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntroCard(),
          // MonthlySpendingChart(),
          RecentTransactions()
        ],
      ),
      bottomNavigationBar : ScreensNavigationBar(),
    );
  }
}
