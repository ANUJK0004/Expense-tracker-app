import 'package:exes/screens/privacy_policy_screen.dart';
import 'package:exes/services/rate_service.dart';
import 'package:exes/services/report_bug_service.dart';
import 'package:exes/services/settings_controller.dart';
import 'package:exes/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.onClearAll,
    required this.onExportJson,
    required this.onImportJson,
    required this.onExportCSV,
  });
  final Future<void> Function() onClearAll;
  final Future<void> Function() onExportJson;
  final Future<void> Function() onImportJson;
  final Future<void> Function() onExportCSV;

  Future<void> showClearDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Clear Transactions"),

          content: const Text(
            "Are you sure you want to delete all transactions?\n\nThis action cannot be undone.",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await onClearAll();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("All transactions deleted")),
        );
      }
    }
  }

  Future<void> showCurrencyDialog(BuildContext context) async {
    final controller = context.read<SettingsController>();

    await showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: const Text("Select Currency"),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              ListTile(
                title: const Text("₹ Indian Rupee"),

                onTap: () {
                  controller.changeCurrency("₹");

                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("\$ US Dollar"),

                onTap: () {
                  controller.changeCurrency("\$");

                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("€ Euro"),

                onTap: () {
                  controller.changeCurrency("€");

                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("£ Pound"),

                onTap: () {
                  controller.changeCurrency("£");

                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("¥ Yen"),

                onTap: () {
                  controller.changeCurrency("¥");

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showDateFormatDialog(BuildContext context) async {
    final controller = context.read<SettingsController>();

    await showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: const Text("Choose Date Format"),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              ListTile(
                title: const Text("dd/MM/yyyy"),

                onTap: () {
                  controller.changeDateFormat("dd/MM/yyyy");

                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("MM/dd/yyyy"),

                onTap: () {
                  controller.changeDateFormat("MM/dd/yyyy");

                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("yyyy-MM-dd"),

                onTap: () {
                  controller.changeDateFormat("yyyy-MM-dd");

                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("MMM dd, yyyy"),

                onTap: () {
                  controller.changeDateFormat("MMM dd, yyyy");

                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("dd MMM yyyy"),

                onTap: () {
                  controller.changeDateFormat("dd MMM yyyy");

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showAnalyticsDialog(BuildContext context) async {
    final controller = context.read<SettingsController>();

    await showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: const Text("Default Analytics Filter"),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              ListTile(
                title: const Text("Daily"),

                onTap: () {
                  controller.changeAnalyticsFilter("Daily");

                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("Weekly"),

                onTap: () {
                  controller.changeAnalyticsFilter("Weekly");

                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("Monthly"),

                onTap: () {
                  controller.changeAnalyticsFilter("Monthly");

                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text("Yearly"),

                onTap: () {
                  controller.changeAnalyticsFilter("Yearly");

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showAccentDialog(BuildContext context) async {
    final controller = context.read<ThemeController>();

    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: const Text("Accent Color"),

          content: Wrap(
            spacing: 10,

            children: AppColors.colors.map((color) {
              return GestureDetector(
                onTap: () {
                  controller.changeAccent(color);

                  Navigator.pop(context);
                },

                child: CircleAvatar(backgroundColor: color),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "Appearance",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),

                SwitchListTile(
                  value: controller.isDarkMode,
                  title: const Text("Dark Mode"),
                  subtitle: const Text("Use dark theme"),
                  secondary: const Icon(Icons.dark_mode),
                  onChanged: controller.toggleTheme,
                ),

                ListTile(
                  leading: const Icon(Icons.palette),
                  title: const Text("Accent Color"),
                  trailing: const Icon(Icons.chevron_right),

                  onTap: () {
                    showAccentDialog(context);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "Data",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.upload_file),
                  title: const Text("Export JSON"),
                  subtitle: const Text("Backup transactions"),
                  onTap: () async {
                    await onExportJson();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          showCloseIcon: true,
                          content: Text("✔ Backup exported successfully"),
                        ),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: const Text("Export CSV"),
                  subtitle: const Text("Excel compatible"),
                  onTap: () async {
                    await onExportCSV();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          showCloseIcon: true,
                          content: Text("CSV exported"),
                        ),
                      );
                    }
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text("Import Backup"),
                  onTap: () async {
                    await onImportJson();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          showCloseIcon: true,
                          content: Text("Transactions imported"),
                        ),
                      );
                    }
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    "Clear All Transactions",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    showClearDialog(context);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "Preferences",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.currency_rupee),
                  title: const Text("Currency"),

                  subtitle: Consumer<SettingsController>(
                    builder: (_, controller, _) {
                      return Text(controller.currency);
                    },
                  ),
                  trailing: const Icon(Icons.chevron_right),

                  onTap: () {
                    showCurrencyDialog(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month),

                  title: const Text("Date Format"),

                  subtitle: Consumer<SettingsController>(
                    builder: (_, controller, _) {
                      return Text(controller.dateFormat);
                    },
                  ),
                  trailing: const Icon(Icons.chevron_right),

                  onTap: () {
                    showDateFormatDialog(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart),

                  title: const Text("Default Analytics Filter"),

                  subtitle: Consumer<SettingsController>(
                    builder: (_, controller, _) {
                      return Text(controller.analyticsFilter);
                    },
                  ),
                  trailing: const Icon(Icons.chevron_right),

                  onTap: () {
                    showAnalyticsDialog(context);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "About",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.star),

                  title: const Text("Rate App"),

                  onTap: () {
                    RateService.rateApp();
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.bug_report),

                  title: const Text("Report Bug"),

                  onTap: () {
                    ReportBugService.reportBug();
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.privacy_tip),

                  title: const Text("Privacy Policy"),
                  trailing: const Icon(Icons.chevron_right),

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                ),

                const Divider(),

                const ListTile(
                  leading: Icon(Icons.info),
                  title: Text("Version"),
                  trailing: Text("1.0.0"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
