import 'package:exes/screens/navigation_screen.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(Exes());
}

class Exes extends StatelessWidget {
  const Exes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exes - an expense tracker',
      debugShowCheckedModeBanner: false,
      home : NavigationScreen(),
    );
  }
}
