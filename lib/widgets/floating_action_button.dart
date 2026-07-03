import 'package:flutter/material.dart';

class AddExpenseButton extends StatelessWidget {
  const AddExpenseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height / 2,
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
              ],
            ),
          ),
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
