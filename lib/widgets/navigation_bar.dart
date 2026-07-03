import 'package:exes/widgets/floating_action_button.dart';
import 'package:flutter/material.dart';

class ScreensNavigationBar extends StatelessWidget {
  const ScreensNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        selectedIndex: 0,
        indicatorColor: Colors.blue.shade100,
        shadowColor: Colors.blue.shade100,
        onDestinationSelected: (int index) {
          if (index == 0) {
            Navigator.of(context).pushNamed('/home');
          } else if (index == 1) {
            Navigator.of(context).pushNamed('lib/screens/analytics_screen.dart');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/history');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/settings');
          }
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
          AddExpenseButton(),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: "History",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ]
    );
  }
}

