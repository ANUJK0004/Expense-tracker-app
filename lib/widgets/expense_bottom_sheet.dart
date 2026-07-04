import 'package:flutter/material.dart';

class ExpenseBottomSheet extends StatelessWidget {
  const ExpenseBottomSheet({super.key});

  // static const DateTime firstDate ;
  // static const DateTime lastDate ;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/2,
      width: MediaQuery.of(context).size.width,
      decoration:BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(23), topRight: Radius.circular(23))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Add Expense",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextField(),
          const SizedBox(height: 16,),
          TextField(),
          // DropdownButtonFormField(items: [], onChanged: (_)),
          // DropdownButtonFormField(items: [], onChanged: (_)),
          // DatePickerDialog(firstDate: 1, lastDate: ),
          const SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          OutlinedButton(onPressed: (){}, child: Text("Cancel")),
              ElevatedButton(onPressed: (){}, child: Text("Add Transaction")),
            ],
          ),
        ],
      ),
    );
  }
}
