import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade300,
      appBar: AppBar(title: Text("Analytics"), centerTitle: true),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.brown.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SegmentedButton(
                    segments:[
                      ButtonSegment(value: 1, label: Text("Daily")),
                      ButtonSegment(value: 2, label: Text("Weekly")),
                      ButtonSegment(value: 3, label: Text("Monthly")),
                      ButtonSegment(value: 4, label: Text("Yearly")),
                    ] ,
                    selected : {2},
                  multiSelectionEnabled: false,
                  emptySelectionAllowed: true,
                )
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
