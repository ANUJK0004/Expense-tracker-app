import 'package:exes/models/expense.dart';
import 'package:exes/services/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key,required this.onFilter});
  final Future<void> Function(ExpenseTransaction transaction) onFilter;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}
enum Type{all,income,expense}

class _FilterBottomSheetState extends State<FilterBottomSheet> {

  final List<DropdownMenuItem<String>> categories = [
    "🍔 Food",
    "🚕 Transport",
    "🛒 Shopping",
    "🎬 Entertainment",
    "🏥 Health",
    "🎓 Education",
    "💼 Salary",
    "🎁 Gift",
    "📈 Investment",
    "📦 Others",
  ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList();
  final List<DropdownMenuItem<String>> sortBy = [
    "Date (Newest First)",
    "Date (Oldest First)",
    "Amount (High to Low)",
    "Amount (Low to High)",
    "Category (A-Z)",
    "Category (Z-A)",
  ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList();

  late Type selectedType ;
  DateTime? selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  String selectedCategory = "🍔 Food";
  final TextEditingController _searchController = TextEditingController();


  @override
  void dispose() {
    _searchController.dispose();
    // _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 55,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Filters",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return "Please enter an a";
                    //   }
                    //   final amount = toString(value);
                    //   if (amount == null) {
                    //     return "Enter a valid number";
                    //   }
                    //   if (amount <= 0) {
                    //     return "Amount must be greater than zero";
                    //   }
                    //   return null;
                    // },
                    controller: _searchController,
                    maxLength: 12,
                    maxLines: 1,
                    selectAllOnFocus: true,
                    enableIMEPersonalizedLearning: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      hintText: "Search",
                      labelText: "Search",
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SegmentedButton<Type>(
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Theme.of(context)
                              .colorScheme
                              .primaryContainer;
                        }

                        return Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest;
                      }),
                    ),
                    selected: <Type>{selectedType},
                    onSelectionChanged: (Set<Type> newSelection) {
                      setState(() {
                        selectedType = newSelection.first;
                      });
                    },
                    segments: [
                      ButtonSegment(value: Type.all, label: Text("All")),
                      ButtonSegment(value: Type.income, label: Text("Income")),
                      ButtonSegment(value: Type.expense, label: Text("Expense")),
                    ],
                    multiSelectionEnabled: false,
                    emptySelectionAllowed: true,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: DropdownButtonFormField(
                    items: categories,
                    initialValue: selectedCategory,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a category";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                    dropdownColor: Theme.of(context).cardColor,
                    decoration: InputDecoration(
                      hintText: "Category",
                      labelText: "Category",
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 2),
                        gapPadding: 10,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                        gapPadding: 10,
                      ),
                    ),
                    menuMaxHeight: 300,
                    borderRadius: BorderRadius.circular(24),
                    padding: EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.calendar_month,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2024),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context),
                                child: child!,
                              );
                            },
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                      ),
                      Text(
                        DateFormat(settings.dateFormat).format(selectedDate!),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Reset"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        if (!context.mounted) return;
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        "Apply Filters",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
