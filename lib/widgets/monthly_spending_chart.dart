import 'package:flutter/material.dart';

class MonthlySpendingChart extends StatelessWidget {
  const MonthlySpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(28), topLeft: Radius.circular(28)),
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
        child: Column(children: [Text("Monthly Spending Chart")]),
      ),
    );
  }
}
