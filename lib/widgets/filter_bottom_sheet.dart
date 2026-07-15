import 'package:exes/models/transaction_filter.dart';
import 'package:exes/services/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

enum Type { all, income, expense }

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final List<DropdownMenuItem<String>> categories = [
    "All",
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

  late Type selectedType;
  DateTime? startSelectedDate;
  DateTime? endSelectedDate;
  final _formKey = GlobalKey<FormState>();
  String selectedCategory = "All";
  String selectedSort = "Date (Newest First)";
  double startAmount = 200.0;
  double endAmount = 1000.0;

  @override
  void initState() {
    super.initState();
    selectedType = Type.all;
  }

  @override
  void dispose() {
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
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedContainer(

                    duration:
                    Duration(milliseconds:250),
                    curve: Curves.ease,
                    child: Column(
                      children: [
                        Text(
                          "Filters",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Find exactly what you're looking for",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    )
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 18,
                    bottom: 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "🧾 Transaction Type",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SegmentedButton<Type>(
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(const Size(110, 50)),
                      backgroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return Theme.of(context).colorScheme.primaryContainer;
                        }

                        return Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest;
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
                      ButtonSegment(
                        value: Type.expense,
                        label: Text("Expense"),
                      ),
                    ],
                    multiSelectionEnabled: false,
                    emptySelectionAllowed: true,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 18,
                    bottom: 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "🏷 Category",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
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
                      prefixIcon: Icon(Icons.category_outlined),
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
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 18,
                    bottom: 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "💰 Amount Range",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            "${settings.currency}${startAmount.toStringAsFixed(0)}",
                          ),

                          Text(
                            "${settings.currency}${endAmount.toStringAsFixed(0)}",
                          ),
                        ],
                      ),
                      RangeSlider(
                        values: RangeValues(100.0, 10000.0),
                        min: 100.0,
                        max: 10000.0,
                        // divisions: 10,
                        activeColor: Theme.of(context).colorScheme.primary,
                        inactiveColor: Theme.of(context).colorScheme.outline,
                        // onChangeStart: (value) {
                        //   setState(() {
                        //     startAmount = value.start;
                        //     endAmount = value.end;
                        //   });
                        // },
                        // onChangeEnd: (value){
                        //   setState(() {
                        //     startAmount = value.start;
                        //     endAmount = value.end;
                        //   });
                        // },
                        labels: RangeLabels(
                          "Start${startAmount.toStringAsFixed(2)}",
                          endAmount.toStringAsFixed(2),
                        ),
                        onChanged: (value) {
                          setState(() {
                            startAmount = value.start;
                            endAmount = value.end;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 18,
                    bottom: 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "📅 Date Range",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: startSelectedDate ?? DateTime.now(),
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
                            startSelectedDate = pickedDate;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),

                        child: Row(
                          children: [
                            Icon(Icons.calendar_today),

                            SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text("Start Date"),
                                  Text(startSelectedDate == null
                                      ? "Select Date"
                                      :
                                    DateFormat(
                                      settings.dateFormat,
                                    ).format(startSelectedDate!),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: startSelectedDate ?? DateTime.now(),
                          firstDate: startSelectedDate ?? DateTime.now(),
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
                            endSelectedDate = pickedDate;
                          });
                        }
                      },

                      borderRadius: BorderRadius.circular(16),

                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,

                          borderRadius: BorderRadius.circular(16),

                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),

                        child: Row(
                          children: [
                            Icon(Icons.calendar_today),

                            SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text("End Date"),

                                  Text(
                                    endSelectedDate == null
                                        ? "End Date"
                                        :
                                    DateFormat(
                                      settings.dateFormat,
                                    ).format(endSelectedDate!),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 18,
                    bottom: 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "⇅ Sort By",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: DropdownButtonFormField(
                    items: sortBy,
                    initialValue: selectedSort,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a Filter";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedSort = value!;
                      });
                    },
                    dropdownColor: Theme.of(context).cardColor,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.sort),
                      hintText: "SortBy",
                      labelText: "SortBy",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      icon:
                      Icon(Icons.refresh),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: Text("Reset"),
                    ),
                    FilledButton.icon(
                      icon:
                      Icon(Icons.check),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        final filter = TransactionFilter(
                          type: selectedType as String,
                          category: selectedCategory,
                          startAmount: startAmount,
                          endAmount: endAmount,
                          startingDate: startSelectedDate!,
                          endDate: endSelectedDate!,
                          sortBy: selectedSort,
                        );
                        if (!context.mounted) return;
                        Navigator.of(context).pop(true);
                      },
                      label: Text("Apply Filters"),
                    ),
                  ],
                ),
                const SizedBox(height:30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
