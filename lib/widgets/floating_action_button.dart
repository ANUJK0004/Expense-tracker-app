import 'package:flutter/material.dart';

class AddExpenseButton extends StatelessWidget {
  const AddExpenseButton({super.key,required this.onPressed});
  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Theme.of(context)
          .floatingActionButtonTheme
          .backgroundColor,
      foregroundColor: Theme.of(context)
          .floatingActionButtonTheme
          .foregroundColor,
      elevation: 3,
      shape: CircleBorder(),
      child: Icon(Icons.add_sharp,size: 44,),
    );
  }
}
