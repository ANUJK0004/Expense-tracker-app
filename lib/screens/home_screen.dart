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
          ),
        ],
      ),
      bottomNavigationBar : NavigationBar(
          selectedIndex: 0,
          indicatorColor: Colors.blue.shade100,
          shadowColor: Colors.blue.shade100,
          onDestinationSelected: (int index) {
            if (index == 2) {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  decoration:BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(23), topRight: Radius.circular(23))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "Add Expense",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            // else if(index == 2){
            //   Navigator.pushNamed(context, '/settings');
            // }
          },
          backgroundColor: Colors.blue.shade700,
          surfaceTintColor: Colors.blue.shade100,
          elevation: 5,
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(
              icon: Icon(Icons.show_chart),
              label: "Analytics",
            ),
            NavigationDestination(icon: Icon(Icons.add), label: "Add"),
            NavigationDestination(
              icon: Icon(Icons.monetization_on),
              label: "Transactions",
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ]
      ),
    );
  }
}
