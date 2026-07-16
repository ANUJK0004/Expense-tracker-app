import 'package:exes/models/expense.dart';
import 'package:exes/models/transaction_filter.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static const table = 'transactions';
  static const _dbName = 'expense_database.db';
  static const _dbVersion = 1;

  Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    const dbName = _dbName;
    final path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) {
        return db.execute('''
            CREATE TABLE $table(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
             amount REAL NOT NULL, 
             category TEXT NOT NULL, 
             note TEXT, 
             type TEXT NOT NULL, 
             date TEXT NOT NULL
             )
             ''');
      },
    );
  }

  Future<int> insertTransaction(ExpenseTransaction transaction) async {
    final db = await database;
    return db.insert(table, transaction.toMap());
  }

  Future<List<ExpenseTransaction>> getAllTransactions() async {
    final db = await database;
    final maps = await db.query(table);

    return maps.map((map) => ExpenseTransaction.fromMap(map)).toList();
  }

  Future<void> updateTransaction(ExpenseTransaction transaction) async {
    final db = await database;
    await db.update(
      table,
      transaction.toMap(),
      where: "id = ?",
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete(table, where: "id = ?", whereArgs: [id]);
  }

  Future<void> clearAllTransactions() async {
    final db = await database;
    await db.delete(table);
  }

  Future<void> insertTransactions(List<ExpenseTransaction> transactions) async {
    final db = await database;

    final batch = db.batch();

    for (final transaction in transactions) {
      batch.insert(
        table,
        transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<ExpenseTransaction>> getFilteredTransactions(
    TransactionFilter filter,
  ) async {
    final db = await database;

    String query = "SELECT * FROM $table WHERE 1 = 1";

    final List<Object?> arguments = [];

    if (filter.type != "All") {
      query += " AND type = ?";
      arguments.add(filter.type);
    }

    if (filter.category != "All") {
      query += " AND category = ?";
      arguments.add(filter.category);
    }

    query += " AND amount >= ?";
    arguments.add(filter.startAmount);

    query += " AND amount <= ?";
    arguments.add(filter.endAmount);

    if (filter.startDate != null) {
      query += " AND date >= ?";
      arguments.add(filter.startDate!.toIso8601String());
    }

    if (filter.endDate != null) {
      query += " AND date <= ?";
      arguments.add(filter.endDate!.toIso8601String());
    }

    switch (filter.sortBy) {
      case "Date (Newest First)":
        query += " ORDER BY date DESC";
        break;

      case "Date (Oldest First)":
        query += " ORDER BY date ASC";
        break;

      case "Amount (High to Low)":
        query += " ORDER BY amount DESC";
        break;

      case "Amount (Low to High)":
        query += " ORDER BY amount ASC";
        break;

      case "Category (A-Z)":
        query += " ORDER BY category ASC";
        break;

      case "Category (Z-A)":
        query += " ORDER BY category DESC";
        break;

      default:
        query += " ORDER BY date DESC";
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery(query, arguments);

    return maps.map((e) => ExpenseTransaction.fromMap(e)).toList();
  }
}
