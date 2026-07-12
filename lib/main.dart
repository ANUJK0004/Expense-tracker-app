import 'package:exes/screens/navigation_screen.dart';
import 'package:exes/services/settings_controller.dart';
import 'package:exes/theme/app_theme.dart';
import 'package:exes/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeController = ThemeController();
  await themeController.loadTheme();

  final settingsController = SettingsController();
  await settingsController.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeController>.value(value: themeController),
        ChangeNotifierProvider<SettingsController>.value(
          value: settingsController,
        ),
      ],
      child: const ExesApp(),
    ),
  );
}

class ExesApp extends StatelessWidget {
  const ExesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Exes - Expense Tracker",

      theme: AppTheme.lightTheme(themeController.seedColor),

      darkTheme: AppTheme.darkTheme(themeController.seedColor),

      themeMode: themeController.themeMode,

      home: const NavigationScreen(),
    );
  }
}
