import 'dart:convert';
import 'dart:io';
import 'package:exes/database/database_helper.dart';
import 'package:exes/models/expense.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ImportExportService {
  ImportExportService._();

  static final instance = ImportExportService._();

  Future<void> exportJson() async {
    try{
      final transactions = await DatabaseHelper.instance.getAllTransactions();

      final json = transactions.map((e) => e.toMap()).toList();

      final jsonString = const JsonEncoder.withIndent("  ").convert(json);

      final directory = await getApplicationDocumentsDirectory();

      final file = File("${directory.path}/expense_backup.json");

      await file.writeAsString(jsonString);

      await SharePlus.instance.share(
        ShareParams(text: "Expense Backup", files: [XFile(file.path)]),
      );
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<void> importJson() async {
    try{
      final picked = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["json"],
      );

      if (picked == null) return;
      final file = File(picked.files.single.path!);
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);

      final transactions = jsonData
          .map((e) => ExpenseTransaction.fromMap(e))
          .toList();
      await DatabaseHelper.instance.insertTransactions(transactions);

    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<void> exportCSV() async {
    try{
      final transactions = await DatabaseHelper.instance.getAllTransactions();

      final rows = <List<dynamic>>[];

      rows.add(["Amount", "Category", "Note", "Type", "Date"]);

      for (final t in transactions) {
        rows.add([
          t.amount,
          t.category,
          t.note,
          t.type,
          t.date.toIso8601String(),
        ]);
      }

      final csv = rows
          .map(
            (row) => row
            .map((e) {
          final value = e.toString().replaceAll('"', '""');
          return '"$value"';
        })
            .join(','),
      )
          .join('\n');

      final directory = await getApplicationDocumentsDirectory();

      final file = File("${directory.path}/expense_backup.csv");

      await file.writeAsString(csv);

      await SharePlus.instance.share(
        ShareParams(text: "Expense CSV", files: [XFile(file.path)]),
      );
    }catch(e){
      debugPrint(e.toString());
    }
  }
}
