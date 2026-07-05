import 'package:exes/screens/navigation_screen.dart';
import 'package:flutter/material.dart';

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ExesApp());
}


class ExesApp extends StatelessWidget {
  const ExesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exes - an expense tracker',
      debugShowCheckedModeBanner: false,
      home : const NavigationScreen(),
    );
  }
}
