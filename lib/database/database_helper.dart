import 'package:exes/models/expense.dart';
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
    return db.insert(
      table,
      transaction.toMap(),
    );
  }

  Future<List<ExpenseTransaction>> getAllTransactions() async {
    final db = await database;
    final maps = await db.query(table);

    return maps
        .map((map) => ExpenseTransaction.fromMap(map))
        .toList();
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
  Future<void> clearTransactions() async {
    final db = await database;
    await db.delete(table);
  }
}
