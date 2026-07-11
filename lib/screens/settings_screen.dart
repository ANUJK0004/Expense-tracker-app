import 'package:exes/services/settings_controller.dart';
import 'package:exes/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.onClearDatabase});
  final Future<void> Function() onClearDatabase;

  Future<void> showDeleteDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete everything?"),
          content: const Text("This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await onClearDatabase();
    }
  }

  Future<void> showCurrencyDialog(BuildContext context) async {
    final settings = context.read<SettingsController>();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Currency"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("₹ Rupee"),
                onTap: () {
                  settings.changeCurrency(Currency.rupee);
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("\$ Dollar"),
                onTap: () {
                  settings.changeCurrency(Currency.dollar);
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("€ Euro"),
                onTap: () {
                  settings.changeCurrency(Currency.euro);
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("£ Pound"),
                onTap: () {
                  settings.changeCurrency(Currency.pound);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.read<ThemeController>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text("Settings"), centerTitle: true),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Theme.of(context).primaryColor,
                shadowColor: Theme.of(context).shadowColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Appearance"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Dark Mode"),
                          Switch(
                            value: themeController.isDarkMode,
                            onChanged: (value) {
                              themeController.toggleTheme(value);
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Accent color"),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.color_lens),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Data management"),
                  TextButton(
                    onPressed: () {},
                    child: Text("⬇ Export Transactions"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("⬆ Import Transactions"),
                  ),
                  TextButton(
                    onPressed: () {
                      showDeleteDialog(context);
                    },
                    child: Text("🗑 Clear All Transactions"),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Preferences"),
                  TextButton(
                    onPressed: () {
                      showCurrencyDialog(context);
                    },
                    child: Text("Currency"),
                  ),
                  TextButton(onPressed: () {}, child: Text("Date Format")),
                  TextButton(
                    onPressed: () {},
                    child: Text("Default Analytics Filter"),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("About"),
                  TextButton(onPressed: () {}, child: Text("Rate App")),
                  TextButton(onPressed: () {}, child: Text("Report Bug")),
                  TextButton(onPressed: () {}, child: Text("Privacy Policy")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
