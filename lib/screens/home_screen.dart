import 'package:exes/utils/text_styles.dart';
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
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade500,
                  Colors.blue.shade200,
                  Colors.blue.shade300,
                  Colors.blue.shade200,
                  Colors.blue.shade500,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Good Morning 👋", style: textStyle),
                      Text("Current Balance", style: textStyle),
                      Text("₹52,480", style: textStyle),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text("Income", style: textStyle),
                          Text("₹52,480", style: textStyle),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Expenses", style: textStyle),
                          Text("22,520", style: textStyle),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.only(topRight: Radius.circular(28), topLeft: Radius.circular(28)),
          //       // gradient: LinearGradient(
          //       //   colors: [
          //       //     Colors.blue.shade500,
          //       //     Colors.blue.shade200,
          //       //     Colors.blue.shade300,
          //       //     Colors.blue.shade200,
          //       //     Colors.blue.shade500,
          //       //   ],
          //       // ),
          //     ),
          //     child: Column(children: [Text("Monthly Spending Chart")]),
          //   ),
          // ),
          Expanded(
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
                  Text("Recent Transactions", style: textStyle),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        ListTile(
                          title: Text("Food"),
                          trailing: Text("₹52,480"),
                        ),
                        ListTile(
                          title: Text("Food"),
                          trailing: Text("₹52,480"),
                        ),
                        ListTile(
                          title: Text("Food"),
                          trailing: Text("₹52,480"),
                        ),
                        ListTile(
                          title: Text("Food"),
                          trailing: Text("₹52,480"),
                        ),
                        ListTile(
                          title: Text("Food"),
                          trailing: Text("₹52,480"),
                        ),
                        ListTile(
                          title: Text("Food"),
                          trailing: Text("₹52,480"),
                        ),
                        ListTile(
                          title: Text("Food"),
                          trailing: Text("₹52,480"),
                        ),
                        ListTile(
                          title: Text("Food"),
                          trailing: Text("₹52,480"),
                        ),
                        ListTile(
                          title: Text("Food"),
                          trailing: Text("₹52,480"),
                        ),

                        // Card(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
