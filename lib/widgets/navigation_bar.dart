import 'package:flutter/material.dart';

class ScreensNavigationBar extends StatelessWidget {
  const ScreensNavigationBar({super.key, required this.currentIndex,required this.changedIndex});
  final ValueChanged<int> changedIndex;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        selectedIndex: currentIndex,
        indicatorColor: Theme.of(context).cardColor,
        shadowColor: Theme.of(context).cardColor,
        onDestinationSelected: (int index) {
          changedIndex(index);
        },
        backgroundColor: Theme.of(context).primaryColor,
        surfaceTintColor: Theme.of(context).shadowColor,
        elevation: 5,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home),selectedIcon: Icon(Icons.home_outlined), label: "Home"),
          NavigationDestination(
            icon: Icon(Icons.show_chart),
            label: "Analytics",
            selectedIcon: Icon(Icons.show_chart_outlined),
            tooltip: "Expenses analysis",
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: "History",
            selectedIcon: Icon(Icons.history_outlined),
            tooltip: "Transactions history",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: "Settings",
            selectedIcon: Icon(Icons.settings_outlined),
          ),
        ]
    );
  }
}

