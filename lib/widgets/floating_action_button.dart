import 'package:exes/widgets/expense_bottom_sheet.dart';
import 'package:flutter/material.dart';

class AddExpenseButton extends StatelessWidget {
  const AddExpenseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){
        showModalBottomSheet(
          context: context,
          builder: (context) => ExpenseBottomSheet(),
        );
      },
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 3,
      shape: CircleBorder(),
      child: Icon(Icons.add_sharp,size: 44,),
    );
  }
}
