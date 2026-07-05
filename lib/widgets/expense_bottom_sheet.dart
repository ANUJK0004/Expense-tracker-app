import 'package:flutter/material.dart';

class ExpenseBottomSheet extends StatefulWidget {
  const ExpenseBottomSheet({super.key});

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
  late DateTime selectedDate = DateTime.now();
  String selectedType = "Expense";
  final String selectedCategory = "Food";
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // static const DateTime firstDate ;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Add Transaction",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Chip(label: Text("Expense")),
              Chip(label: Text("Income")),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _amountController,
              maxLength: 12,
              maxLines: 1,
              selectAllOnFocus: true,
              enableIMEPersonalizedLearning: true,
              enableInlinePrediction: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                hintText: "Amount",
                labelText: "Amount",
                hintFadeDuration: Duration(seconds: 1),
                // errorText: "Enter a valid amount",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue.shade200, width: 2),
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
          const SizedBox(height: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: DropdownButtonFormField(
              items: categories,
              onChanged: (categories) {},
              // onTap: () {},
              decoration: InputDecoration(
                hintText: "Category",
                labelText: "Category",
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue.shade200, width: 2),
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
          const SizedBox(height: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _noteController,
              maxLength: 120,
              selectAllOnFocus: true,
              enableIMEPersonalizedLearning: true,
              enableInlinePrediction: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                hintText: "Note",
                labelText: "Note",
                hintFadeDuration: Duration(seconds: 1),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue.shade200, width: 2),
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
          const SizedBox(height: 12),
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_month),
                  onPressed: () {
                    setState(() {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.parse("2023-05-05"),
                        firstDate: DateTime.parse("2023-05-05"),
                        lastDate: DateTime.now(),
                      ) as DateTime;
                    });
                  },
                ),
                Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(onPressed: () {}, child: Text("Cancel")),
              ElevatedButton(onPressed: () {}, child: Text("Save")),
            ],
          ),
        ],
      ),
    );
  }
}
