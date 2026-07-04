import 'package:flutter/material.dart';

class TransactionsHistory extends StatelessWidget {
  const TransactionsHistory({super.key});

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
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Chip(label: Text("Travel")),
                  Chip(label: Text("Salary")),
                  Chip(label: Text("Transportation")),
                  Chip(label: Text("Food")),
                  Chip(label: Text("Travel")),
                  Chip(label: Text("Salary")),
                  Chip(label: Text("Transportation")),
                  Chip(label: Text("Food")),
                ],
              ),
            ),
            Divider(color: Colors.brown),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemBuilder: (context, index ) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.dinner_dining),
                          title: Text("Food"),
                          trailing: Text("₹52,480"),
                        ),
                        Divider(color: Colors.brown),
                      ],
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
