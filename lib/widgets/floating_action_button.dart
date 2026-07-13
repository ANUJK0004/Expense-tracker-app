import 'package:flutter/material.dart';

class AddExpenseButton extends StatelessWidget {
  const AddExpenseButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: "Add Transaction",
      onPressed: onPressed,
      child: const Icon(
        Icons.add_rounded,
        size: 32,
      ),
    );
  }
}