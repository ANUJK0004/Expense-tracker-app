  import 'package:exes/screens/navigation_screen.dart';
import 'package:exes/theme/app_theme.dart';
import 'package:exes/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/settings_controller.dart';

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  final controller = ThemeController();
  await controller.loadTheme();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => controller,
      ),
      ChangeNotifierProvider(
        create: (_) => SettingsController()..loadSettings(),
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

    final themeController = Provider.of<ThemeController>(context);
    return MaterialApp(
      title: 'Exes - an expense tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      home: const NavigationScreen(),
    );
  }
}
