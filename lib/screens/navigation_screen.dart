import 'package:exes/screens/analytics_screen.dart';
import 'package:exes/screens/history_screen.dart';
import 'package:exes/screens/home_screen.dart';
import 'package:exes/screens/settings_screen.dart';
import 'package:exes/widgets/floating_action_button.dart';
import 'package:exes/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentIndex = 0;

  final screens = [
    HomeScreen(),
    AnalyticsScreen(),
    TransactionsHistory(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      bottomNavigationBar: ScreensNavigationBar(
        changedIndex: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
      ),
      body: screens[currentIndex],
      floatingActionButton: AddExpenseButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
