import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

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
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                dragStartBehavior: DragStartBehavior.down,
                scrollDirection: Axis.vertical,
                children: [
                  ListTile(
                    leading: Icon(Icons.dinner_dining),
                    title: Text("Food"),
                    trailing: Text("₹52,480"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.dinner_dining),
                    title: Text("Food"),
                    trailing: Text("₹52,480"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.dinner_dining),
                    title: Text("Food"),
                    trailing: Text("₹52,480"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.dinner_dining),
                    title: Text("Food"),
                    trailing: Text("₹52,480"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.dinner_dining),
                    title: Text("Food"),
                    trailing: Text("₹52,480"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.dinner_dining),
                    title: Text("Food"),
                    trailing: Text("₹52,480"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.dinner_dining),
                    title: Text("Food"),
                    trailing: Text("₹52,480"),
                  ),
                  Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
