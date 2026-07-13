import 'package:flutter/material.dart';

class ScreensNavigationBar extends StatelessWidget {
  const ScreensNavigationBar({
    super.key,
    required this.currentIndex,
    required this.changedIndex,
  });

  final int currentIndex;
  final ValueChanged<int> changedIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: changedIndex,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: "Home",
        ),

        NavigationDestination(
          icon: Icon(Icons.show_chart_outlined),
          selectedIcon: Icon(Icons.show_chart),
          label: "Analytics",
        ),

        NavigationDestination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: "History",
        ),

        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}