import 'package:exes/models/expense.dart';
import 'package:exes/services/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseBottomSheet extends StatefulWidget {
  const ExpenseBottomSheet({
    super.key,
    this.transaction,
    this.onAdd,
    this.onUpdate,
  });
  final ExpenseTransaction? transaction;
  final Future<void> Function(ExpenseTransaction transaction)? onAdd;
  final Future<void> Function(ExpenseTransaction transaction)? onUpdate;

  @override
  State<ExpenseBottomSheet> createState() => _ExpenseBottomSheetState();
}

class _ExpenseBottomSheetState extends State<ExpenseBottomSheet> {
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
  DateTime? selectedDate = DateTime.now();
  String selectedType = "Income";
  String selectedCategory = "🍔 Food";
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _amountController.text = widget.transaction!.amount.toString();

      _noteController.text = widget.transaction!.note;

      selectedCategory = widget.transaction!.category;

      selectedType = widget.transaction!.type;

      selectedDate = widget.transaction!.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
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
                  widget.transaction == null
                      ? "Add Transaction"
                      : "Edit Transaction",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceChip(
                      label: const Text("Expense"),
                      selected: selectedType == "Expense",
                      onSelected: (_) {
                        setState(() {
                          selectedType = "Expense";
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text("Income"),
                      selected: selectedType == "Income",
                      onSelected: (_) {
                        setState(() {
                          selectedType = "Income";
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter an amount";
                      }
                      final amount = double.tryParse(value);
                      if (amount == null) {
                        return "Enter a valid number";
                      }
                      if (amount <= 0) {
                        return "Amount must be greater than zero";
                      }
                      return null;
                    },
                    controller: _amountController,
                    maxLength: 12,
                    maxLines: 1,
                    selectAllOnFocus: true,
                    enableIMEPersonalizedLearning: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      hintText: "Amount",
                      labelText: "Amount",
                    ),
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
                    // alignment : AlignmentDirectional.centerStart,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    controller: _noteController,
                    maxLength: 120,
                    selectAllOnFocus: true,
                    enableIMEPersonalizedLearning: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      hintText: "Note",
                      labelText: "Note",
                      hintFadeDuration: Duration(seconds: 1),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 2),
                        gapPadding: 10,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                          style: BorderStyle.solid,
                          strokeAlign: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        gapPadding: 10,
                      ),
                    ),
                  ),
                ),
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
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final transaction = ExpenseTransaction(
                          id: widget.transaction?.id,
                          amount: double.parse(_amountController.text),
                          category: selectedCategory,
                          note: _noteController.text.trim(),
                          type: selectedType,
                          date: selectedDate!,
                        );
                        if (widget.transaction == null) {
                          await widget.onAdd!(transaction);
                        } else {
                          await widget.onUpdate!(transaction);
                        }
                        if (!context.mounted) return;
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        widget.transaction == null ? "Add" : "Update",
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
